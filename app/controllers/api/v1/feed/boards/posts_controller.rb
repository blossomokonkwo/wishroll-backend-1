class Api::V1::Feed::Boards::PostsController < APIController
    before_action :authorize_by_access_header!

    def index 
        offset = params[:offset]
        limit = params[:limit] || 12 
        feed_users = current_user.followed_users.to_a << @current_user
        @posts = Post.includes([:board]).joins(:user).where(user: feed_users)
                .or(Post.where(board: current_user.boards))
                .and(Post.where.not(user: @current_user.blocked_users))
                .and(Post.where.not(id: @current_user.reported_posts))
                .and(Post.where.not(user: @current_user.blocker_users))
                .order(created_at: :desc)
                .offset(offset)
                .limit(limit)
                .to_a
        if @posts.any?
            render :index, status: :ok
        else
            @posts = Post.where(restricted: false).where.not(user: @current_user.blocked_users.select(:id)).and(Post.where.not(id: @current_user.reported_posts)).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(limit).to_a
            if @posts.any?
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        end
    end
end