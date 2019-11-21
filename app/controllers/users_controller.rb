class UsersController < ApplicationController
  before_action :authorize_by_access_header!
  def edit
    #current_user
  end
  def profile
    @user = {:first_name => current_user.first_name, last_name: current_user.last_name, 
      bio: current_user.bio}
    render json: @user, status: :ok
  end

  private def require_user_fields
    params.permit :email, :first_name, :last_name, :orginization
  end
end
