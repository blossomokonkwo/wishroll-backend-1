class UsersController < ApplicationController
  before_action :authorize_by_access_header!
  def show
    @user = User.includes([:posts]).find_by(username: params[:username])
    @current_user = current_user
    render :show, status: :ok
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

#users can update their username. If the new requested username is already taken, a 400 response is returned to the client
 def update_username
  current_user.update(username: update_username_params)
  if current_user.save
    render json: {success: "Your username was successfully updated"}, status: :ok
  else
    render json: {error: "That username is already taken"}, status: 400
  end
 end

 #users can easily and frequently update their profile picture
 def update_profile_picture
  current_user.profile_picture.attach params[:profile_picture]
  render json: {success: "Your profile picture has successfully been updated"}, status: :ok
 end

 def update_name
  current_user.first_name = params[:first_name]
  current_user.last_name = params[:last_name]
  if current_user.save
    render json: {success: "Your name has been updated"}, status: :ok
  else
    render json: {error: "Your name could not be updated at this time"}, status: 400
  end
 end

 def update_bio
  current_user.bio = params[:bio]
  if current_user.save
    render json: {success: "Your bio has been updated"}, status: :ok
  else
    render json: {error: "Your bio could not be updated at this time"}, status: 400
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
  #these param hash permissions ensure that only the correct data is being passed in to the params hash that will ultimately alter the state of the users account 
  def update_username_params
    params.permit :username
  end 

end
