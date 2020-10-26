class V3::Search::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 18
        offset = params[:offset]
        @posts = Post.fetch_multi(Tag.joins(post: {media_item_attachment: :blob}).where("active_storage_blobs.content_type ILIKE ?", "%#{params['content-type']}%").new_search(params[:q]).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end