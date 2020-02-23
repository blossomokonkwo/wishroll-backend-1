class UsersController < ApplicationController
  before_action :authorize_by_access_header!

  def show
    @user = User.find_by(username: params[:username])
    @current_user = current_user
    if @user
      render :show, status: :ok
    else
      render json: nil, status: 404
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
  current_user.update(update_user)
  params.permit :profile_picture
  if params[:profile_picture]
    current_user.profile_picture.purge_later
    current_user.profile_picture.attach params[:profile_picture]
  end
  if current_user.save
    render json: {profile_picture_url: url_for(current_user.profile_picture)}, status: :ok
  else
    render json: nil, status: 400
  end
 end

  def followers 
    @user = User.find_by(username: params[:username])
    @current_user = current_user
    @followers = @user.follower_users
    if @followers.present?
      render :followers, status: 200
    else
      render json: nil, status: 404
    end
  end

  def following
    @current_user = current_user
    @user = User.find_by(username: params[:username])
    @followed_users = @user.followed_users
    if @followed_users.present?
      render :following, status: 200
    else
      render json: nil, status: 404
    end
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
    params.permit :username, :email, :full_name, :bio, :is_verified
  end
end
