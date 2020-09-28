class V3::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 9
        offset = params[:offset]
        document_text = Post.fetch(params[:post_id]).tags.pluck(:text).flatten[0]
        if content_type = params["content-type"] #if the reccommendation is specified by a content-type, search for all similar posts with the specified content type
            @posts = Post.fetch_multi(Tag.joins(post: {media_item_attachment: :blob}).where("active_storage_blobs.content_type ILIKE ?", "%#{content_type}%").recommend(document_text).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}
        else
            @posts = Post.fetch_multi(Tag.recommend(document_text).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}
        end
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end        
    end
    
end