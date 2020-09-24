class V3::Discover::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 15
        offset = params[:offset]
        @posts = Post.includes(:user).where(restricted: false).order(popularity_rank: :desc).offset(offset).limit(limit).to_a
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok  
        else
            render json: nil, status: :not_found
        end
    end
end