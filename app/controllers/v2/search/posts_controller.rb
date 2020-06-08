class V2::Search::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        @id = current_user.id
        limit = 12
        offset = params[:offset]
        @posts = Post.left_outer_joins(:tags).where("text ILIKE ?", "%#{params[:q]}%").includes([user: [:blocked_users]], :views, :likes).distinct.order(likes_count: :desc, view_count: :desc, created_at: :desc, id: :asc).offset(offset).limit(limit)
        @posts.to_a.delete_if do |post|
            current_user.reported_posts.include?(post) or current_user.blocked_users.include?(post.user) or post.user.blocked_users.include?(current_user)
        end
        CreateSearchJob.perform_now(:post, params[:q], params[:ip_address], params[:timezone])
        if @posts.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end