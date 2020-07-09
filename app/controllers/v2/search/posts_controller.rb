class V2::Search::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        limit = 15
        offset = params[:offset]
        @posts = Post.joins(:tags).where("text ILIKE ?", "%#{params[:q]}%").distinct.order(view_count: :desc).offset(offset).limit(limit)
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end