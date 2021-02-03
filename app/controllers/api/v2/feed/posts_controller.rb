class Api::V2::Feed::PostsController < APIController
    
    def index
        begin
            # fetch the access tokens from the request header
            authorize_by_access_header!
            offset = params[:offset]
            limit = 18

            # create an array of the current user's followed users and appen the current user to the array.
            feed_users = current_user.followed_users.to_a << current_user

            # return all posts created by the users in the feed_users array
            @posts = Post.includes(:user).where(user: feed_users).order(created_at: :desc).offset(offset).limit(limit)

            # check that posts isn't empty
            if @posts.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        rescue => exception
            # handle the case where a user isn't signed in to view their feed maybe recommending posts to the user

            render json: nil, status: :unauthorized
            
        end

    end
    
    
end