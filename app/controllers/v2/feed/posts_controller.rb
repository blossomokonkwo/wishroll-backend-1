class V2::Feed::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def feed
        offset = params[:offset]
        limit = 18
        feed_users = current_user.followed_users.to_a
        feed_users << current_user
        @posts = Post.includes(:user).where(user: feed_users).order(created_at: :desc).offset(offset).limit(limit)
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end