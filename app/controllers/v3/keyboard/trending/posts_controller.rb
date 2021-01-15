class V3::Keyboard::Trending::PostsController < ApplicationController
    def index
        offset = params[:offset]
        limit = 15
        #for now return only WishRoll's posts to the keyboard. Later on when a reccomender system is established, recommended posts will be returned instead
        @posts = Post.order(popularity_rank: :desc).offset(params[:offset]).limit(limit).to_a
        if @posts.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end