class V2::Search::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        @id = current_user.id
        limit = 15
        offset = params[:offset]
        @posts = Post.left_outer_joins(:tags).where("text ILIKE ?", "%#{params[:q]}%").includes([user: [:blocked_users]], :views, :likes).distinct.order(likes_count: :desc, view_count: :desc, created_at: :desc, id: :asc).offset(offset).limit(limit)
        @posts.to_a.delete_if do |post|
            current_user.reported_posts.include?(post) or current_user.blocked_users.include?(post.user) or post.user.blocked_users.include?(current_user)
        end
        if @posts.any?
            render :index, status: 200
        else
            render json: nil, status: 404
        end
    end
    

end