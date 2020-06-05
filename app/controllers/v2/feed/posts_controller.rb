class V2::Feed::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def feed
        offset = params[:offset]
        limit = 25
        @posts = Post.where(user: current_user.followed_users).order(created_at: :desc).offset(offset).limit(limit)
        if @posts.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end