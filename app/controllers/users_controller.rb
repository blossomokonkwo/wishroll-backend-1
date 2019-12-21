class UsersController < ApplicationController
  before_action :authorize_by_access_header!
  def show
    @user = current_user
    # we want to return a users username and their photos
    render json: {email: @user.email, posts: @user.posts}, status: :ok
  end

  def destroy
    @object = Object.find(params[:id])
    if @object.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to objects_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to objects_url
    end
  end

  def update
    @object = Object.find(params[:id])
      if @object.update_attributes(params[:object])
        flash[:success] = "Object was successfully updated"
        redirect_to @object
      else
        flash[:error] = "Something went wrong"
        render 'edit'
      end
  end

  private def require_user_fields
    params.permit :email, :first_name, :last_name
  end
end
