class V3::UsersController < ApplicationController
    before_action :authorize_by_access_header!
    
    def show
        if params[:username]
            @user = User.fetch_by_username(params[:username])
        elsif params[:id]
            @user =  User.fetch(params[:id])
        end
        if stale?(@user)
            if @user
                if current_user.blocked?(@user)
                    render json: {id: @user.id, can_unblock: true}, status: :forbidden
                elsif @user.blocked?(current_user)
                    render json: {id: @user.id, can_unblock: false}, status: :forbidden
                else
                    @following = nil
                    if current_user.id != @user.id
                        @following = current_user.following?(@user)
                    end
                    render :show, status: :ok
                end
            else
                render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found
            end
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

    private def update_params
        params.permit :username, :email, :name, :avatar, :profile_background_media, :bio
    end
    
    
end