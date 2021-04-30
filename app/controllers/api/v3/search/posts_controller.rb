class Api::V3::Search::PostsController < ApplicationController

    def index
        limit = 18
        offset = params[:offset]
        @posts = Post.where(id: Tag.joins(post: {media_item_attachment: :blob}).where("active_storage_blobs.content_type ILIKE ?", "%#{params['content-type']}%").search(params[:q]).limit(limit).offset(offset).pluck(:post_id)).distinct
        if @posts.any?            
            begin
                authorize_by_access_header!
                @current_user = current_user
                @posts = @posts.where.not(id: @current_user.reported_posts, user: @current_user.blocked_users, user: @current_user.blocker_users)
                render :index, status: :ok
            rescue => exception                
                #   handle unauthorization
                render :index, status: :ok
            end
        else
            render json: nil, status: :not_found
        end
    end
    
end