class V2::Search::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        limit = 15
        offset = params[:offset]
        @posts = Post.joins(:tags).where("text ILIKE ?", "%#{params[:q]}%").includes([user: [:blocked_users]], :views, :likes).distinct.order(likes_count: :desc, view_count: :desc, created_at: :desc, id: :asc).offset(offset).limit(limit)
        @posts.to_a.delete_if do |post|
            current_user.reported_posts.include?(post)
        end
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end