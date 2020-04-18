class V2::RelationshipsController < ApplicationController
    before_action :authorize_by_access_header!

    def followers
        offset = params[:offset] || 0
        limit = 15
        @user = User.find_by(username: params[:username])
        @current_user = current_user
        @followers = @user.follower_users.offset(offset).limit(limit)
        if @followers.any?
            render :followers, status: :ok
        else
            render json: nil, status: :not_found
        end 
    end
    

    def following
        offset = params[:offset] || 0
        limit = 15
        @current_user = current_user
        @user = User.find_by(username: params[:username])
        @followed_users = @user.followed_users.offset(offset).limit(limit)
        if @followed_users.any?
            render :following, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end