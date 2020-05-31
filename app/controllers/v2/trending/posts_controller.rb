class V2::Trending::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def trending 
        #the number of posts that are sent to the users feed page. The feed sends the most popular posts
        limit = 18
        @id = current_user.id
        offset = params[:offset] #as the user scrolls the offset is incremented by 100
        @posts = Post.includes([:user]).order(created_at: :asc).offset(offset).limit(limit)
        if @posts.any?
            render :index, status: :ok  
        else
            render json: nil, status: :not_found
        end
    end
end