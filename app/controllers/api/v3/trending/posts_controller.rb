class Api::V3::Trending::PostsController < APIController
    
    def index
        begin
            # fetch the access tokens from the request header
            authorize_by_access_header!

            # set the @current_user instance variable
            @current_user = current_user

            # set the offset and limit
            offset = params[:offset]
            limit = 25
            trending_users = User.where(id: [5500, 2997, 4493, 123])
            @posts = Post.joins(:user).where(restricted: false).where(user: trending_users).where.not(user: @current_user.blocked_users.select(:id)).and(Post.where.not(id: @current_user.reported_posts)).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(25) 

            # check that posts array isn't empty
            if @posts.any?
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end

        rescue => exception
            # handle the case where a user isn't signed in to view their feed maybe recommending posts to the user
            puts exception
            @posts = Post.where(restricted: false).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(25)

            if @posts.any?
                render json: @posts, status: :ok
            else
                render json: nil, status: :not_found
            end
        end

    end
    
    
end