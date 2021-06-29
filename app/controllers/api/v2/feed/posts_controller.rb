class Api::V2::Feed::PostsController < APIController
    
    def index
        begin
            # fetch the access tokens from the request header
            authorize_by_access_header!

            # set the @current_user instance variable
            @current_user = current_user

            # set the offset and limit
            offset = params[:offset]
            limit = 25

            # create an array of the current user's followed users and appen the current user to the array.
            feed_users = current_user.followed_users.to_a << @current_user

            # return all posts created by the users in the feed_users array
            @posts = Post.joins(:user).where(user: feed_users).or(Post.where(restricted: false)).where.not(user: @current_user.blocked_users.select(:id)).and(Post.where.not(id: @current_user.reported_posts)).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(25)

            # check that posts array isn't empty
            if @posts.any?
                render :index, status: :ok
            else
                @posts = Post.includes(:user).joins(:user).where(restricted: false).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(25)
                if @posts.any? 
                    render :index, status: :ok
                else
                    render json: nil, status: :not_found
                end
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