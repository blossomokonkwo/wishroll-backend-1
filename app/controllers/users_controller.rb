class UsersController < ApplicationController
  before_action :authorize_by_access_header!
  #after_action :update_profile_picture, only: :update

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
  current_user.profile_picture_url = url_for(current_user.profile_picture) if params[:profile_picture]
  render json: {success: "Your account has been updated"}, status: :ok
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
    params.permit :username, :email, :full_name, :profile_picture, :bio, :is_verified
  end

  def update_profile_picture
    current_user.profile_picture_url = url_for(current_user.profile_picture) if current_user.profile_picture.attached?
  end

end
