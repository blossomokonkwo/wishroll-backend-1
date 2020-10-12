class V2::Trending::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def trending 
        #the number of posts that are sent to the users feed page. The feed sends the most popular posts
        limit = 18
        offset = params[:offset]
        @posts = Post.order(popularity_rank: :desc).offset(offset).limit(limit).to_a.shuffle!
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok  
        else
            render json: nil, status: :not_found
        end
    end
end