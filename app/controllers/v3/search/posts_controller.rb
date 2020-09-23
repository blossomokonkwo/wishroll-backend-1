class V3::Search::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 18
        offset = params[:offset]
        @posts = Post.fetch_multi(Tag.search(params[:q]).offset(offset).limit(limit).pluck(:post_id)).filter {|p| p.media_item.content_type.include?(params["content-type"])}
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end