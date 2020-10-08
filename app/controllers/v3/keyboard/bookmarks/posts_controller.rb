class V3::Keyboard::Bookmarks::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index 
        offset = params[offset]
        limit = 15
        @posts = Post.joins(:bookmarks, media_item_attachment: :blob).where(bookmarks: {user: current_user}).where('active_storage_blobs.content_type ILIKE ?', "%#{params[:content_type]}%").order("bookmarks.created_at DESC").offset(offset).limit(limit).to_a
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
end