class V3::Keyboard::Bookmarks::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index 
        offset = params[offset]
        limit = 15
        @posts = current_user.bookmarked_posts(limit: limit, offset: offset).where('active_storage_blobs.content_type ILIKE ?', "%#{params[:content_type]}%").to_a
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
end