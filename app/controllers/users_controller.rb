class UsersController < ApplicationController
  before_action :authorize_by_access_header!
  def show
    @user = current_user
    # we want to return a users username and their photos
    postsArray = Array.new
    for post in @user.posts
      post_hash = Hash.new
      post_hash["id"] = post.id
      post_hash["user_id"] = post.user_id
      post_hash["created_at"] = post.created_at
      post_hash["view_count"] = post.view_count
      post_hash["caption"] = post.caption
      post_hash["image_url"] = url_for post.post_image
      postsArray << post_hash
    end
    render json: postsArray, status: :ok
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

 

  private 
  #these param hash permissions ensure that only the correct data is being passed in to the params hash that will ultimately alter the state of the users account 
  def update_username_params
    params.permit :username
  end 

end
