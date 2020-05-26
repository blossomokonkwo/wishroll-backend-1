class UsersController < ApplicationController
  before_action :authorize_by_access_header!

  def show
    @user = User.find_by(username: params[:username])
    @current_user = current_user
    if @current_user.blocked_users.include?(@user) or @user.blocked_users.include?(@current_user)
      render json: nil, status: 403 #the 403 status signifies that a user is blocked/forbidden from the requested content
    else
      if @user
        render :show, status: :ok
      else
        render json: nil, status: 404
      end
    end
  end

#users can update their password; however, they have to be authenticated via the session and provide their old password
 def update_password
  #on the client side, ensure that the user has only three chances to change their password within a given session
    if current_user.authenticate(params[:old_password])
      current_user.password = params[:new_password]
      current_user.save
      render json: {success: "Your password has successfully been changed"}, status: :ok
    else
      render json: {error: "Your old password is incorrect"}, status: 400
    end
 end

 def update
  if params[:full_name]
    current_user.update!(name: params[:full_name])
  end
  if params[:username]
    current_user.update!(username: params[:username])
  end
  if params[:bio]
    current_user.update!(bio: params[:bio])
  end
  if params[:email]
    current_user.update!(email: params[:email])
  end
  if params[:profile_picture]
    current_user.update!(avatar: params[:profile_picture])
    current_user.avatar_url = url_for(current_user.avatar) if current_user.avatar.attached? 
  end
  if current_user.save
    render json: {profile_picture_url: current_user.avatar_url}, status: :ok
  else
    render json: nil, status: 400
  end
 end

  def followers 
    @user = User.find_by(username: params[:username])
    @current_user = current_user
    @followers = @user.follower_users
    if @followers.any?
      render :followers, status: 200
    else
      render json: nil, status: 404
    end
  end

  def following
    @current_user = current_user
    @user = User.find_by(username: params[:username])
    @followed_users = @user.followed_users
    if @followed_users.any?
      render :following, status: 200
    else
      render json: nil, status: 404
    end
  end

  def block
    #find and isntatiate User objects based on the parameters passed through the query string
    #check if the current_user currently follows or is followed by the blocked user
    #if so destroy the relationship in either way (that is: force the blocked_user to unfollow the current_user)
    #finally, add the blocked user to the current users blocked users collection
    @current_user = current_user
    @blocked_user = User.find_by(username: params[:blocked_user])
    if @current_user.follower_users.include?(@blocked_user)
        Relationship.find_by(followed_id: @current_user.id, follower_id: @blocked_user.id).destroy
    elsif @current_user.followed_users.include?(@blocked_user)
        Relationship.find_by(followed_id: @blocked_user.id, follower_id: @current_user.id).destroy
    end
    @current_user.blocked_users << @blocked_user
end

 def destroy
    #destroys the users record from the database. The user must send their current password to ensure that they have the authorization to delete the current_user's account
    if current_user.authenticate(params[:password])
      if current_user.destroy
        render json: {success: "You successfully deleted your account"}, status: :ok
      else
        render json: {error: "Your account could not be deleted at this time"}, status: 400
      end
    else
      render json: nil, status: :unauthorized
    end
 end

  private 
  #these param hash permissions ensure that only the correct data is being passed in to the params hash 
  #that will ultimately alter the state of the users account 
  def update_user
    params.permit :username, :email, :full_name, :bio, :is_verified, :profile_picture, :device_token
  end
end
