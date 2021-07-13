class Api::V3::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 15
        offset = params[:offset]
        post_id = params[:post_id]
        document_text = Post.fetch(post_id).tags.pluck(:text).flatten[0]
        if content_type = params["content-type"] #if the reccommendation is specified by a content-type, search for all similar posts with the specified content type
            @posts = Post.where(id: Tag.joins(post: {media_item_attachment: :blob}).where("active_storage_blobs.content_type ILIKE ? AND posts.id != ?", "%#{content_type}%", post_id).recommend(document_text).limit(limit).offset(offset).pluck(:post_id)).and(Post.where.not(id: current_user.reported_posts)).and(Post.where.not(user: current_user.blocked_users)).and(Post.where.not(user: current_user.blocker_users)).distinct
        else
            @posts = Post.includes([:board, :user]).where(id: Tag.joins(:post).where("posts.id != ?", post_id).recommend(document_text).limit(limit).offset(offset).pluck(:post_id))
            .and(Post.where.not(id: current_user.reported_posts))
            .and(Post.where.not(user: current_user.blocked_users))
            .and(Post.where.not(user: current_user.blocker_users))
            .and(Post.where(restricted: false))
            .limit(limit)
            .offset(offset)
            .distinct
            .to_a
        end
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end        
    end
    
end