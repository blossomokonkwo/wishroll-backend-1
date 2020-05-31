class V2::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        limit = 15
        offset = params[:offset]
        @id = current_user.id
        @post = Post.find(params[:post_id])
        keywords = @post.tags.pluck(:text)
        @posts = Post.joins(:tags).where(tags: {text: keywords}).distinct.includes([user: :blocked_users]).order(likes_count: :desc, view_count: :desc, id: :asc).offset(offset).limit(limit).to_a
        @posts.delete_if do |p|
            p.id == @post.id or current_user.reported_posts.include?(p) or p.user.blocked_users.include?(current_user) or current_user.blocked_users.include?(p.user)
        end
        if @posts.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end