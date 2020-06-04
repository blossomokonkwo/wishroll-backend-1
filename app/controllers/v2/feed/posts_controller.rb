class V2::Feed::PostsController < ApplicationController
    def feed
        offset = params[:offset]
        limit = 25
        @posts = Post.order(id: :asc).offset(offset).limit(limit)
        if @posts.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end