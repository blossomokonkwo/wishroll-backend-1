class Api::V2::Feed::RollsController < APIController

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

            # return all rolls created by the users in the feed_users array
            @rolls = Roll.where(restricted: false).order(created_at: :desc).limit(limit)  #Roll.includes(:user).where(user: feed_users).order(created_at: :desc).offset(offset).limit(limit)

            # check that rolls array isn't empty
            if @rolls.any?
                render :index, status: :ok
            else
                @rolls = Roll.where(restricted: false).order(created_at: :desc).limit(25)
                if @rolls.any? 
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