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
  def update
    @user = current_user
    if @user.update(user_update_params)
        render status: :ok
    else
        render status: 404
    end
  end

  private def require_user_fields
    params.permit :email, :first_name, :last_name
  end
  def user_update_params
    params.permit :email, :password
  end  
end
