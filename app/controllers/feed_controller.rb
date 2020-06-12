class FeedController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        @id = current_user.id
        @posts = Post.includes(:user).where(user: current_user.followed_users).order(created_at: :desc).all
        if @posts.any? 
            render :index, status: :ok
        else
            render json: {error: "There are no posts in your feed"}, status: :not_found
        end        
    end
end
