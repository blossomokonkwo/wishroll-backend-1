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
            @posts = Post.includes(user: [:blocked_users, :blocker_users, :reported_posts]).joins(user: [:blocker_users, :blocked_users]).where(user: feed_users).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(limit)

            # check that posts array isn't empty
            if @posts.any?
                render :index, status: :ok
            else
                @posts = Post.where(restricted: false).order(created_at: :desc, popularity_rank: :desc).offset(offset).limit(limit)
                if @posts.any? 
                    render :index, status: :ok
                else
                    render json: nil, status: :not_found
                end
            end

        rescue => exception
            # handle the case where a user isn't signed in to view their feed maybe recommending posts to the user
            puts exception
            render json: nil, status: :unauthorized
        end

    end
    
    
end