class TrendingController < ApplicationController
    before_action :authorize_by_access_header!
    def trending 
        limit = 25
        @id = current_user.id
        offset = params[:offset]
        @posts = Post.includes([:user]).order(popularity_rank: :desc).offset(offset).limit(limit)
        if @posts.any?
            render :index, status: :ok  
        else
            render json: nil, status: :not_found
        end
    end
end
