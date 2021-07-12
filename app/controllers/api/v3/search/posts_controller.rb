class Api::V3::Search::PostsController < ApplicationController
    before_action :authorize_by_access_header!

    def index
        limit = params[:limit] || 10
        limit = 10 if limit.to_i > 10
        offset = params[:offset]
        current_user
        @posts = Post.includes([:board]).where(id: Tag.joins(post: {media_item_attachment: :blob}).where("active_storage_blobs.content_type ILIKE ?", "%#{params['content-type']}%").search(params[:q]).pluck(:post_id))
        .and(Post.where.not(id: @current_user.reported_posts, user: @current_user.blocked_users, user: @current_user.blocker_users))   
        .limit(limit)
        .offset(offset)
        .distinct
        if @posts.any?            
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end