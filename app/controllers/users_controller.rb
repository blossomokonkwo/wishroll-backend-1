class UsersController < ApplicationController
  before_action :authorize_by_access_header!
  def show
    @user = current_user
    # we want to return a users username and their photos
    render json: @user.posts, status: :ok
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
