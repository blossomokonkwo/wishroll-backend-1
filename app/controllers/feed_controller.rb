class FeedController < ApplicationController

    def index
        begin
            # fetch the access tokens from the request header
            authorize_by_access_header!
            offset = params[:offset]
            limit = 12
            feed_users = current_user.followed_users.to_a
            feed_users << current_user
            @rolls = Roll.where(user: feed_users).order(created_at: :desc).offset(offset).limit(limit).to_a
            if @rolls.any?
                @current_user = current_user

                respond_to do |format|
                    format.html {render :index, status: :ok}
                    format.json {render :index, status: :ok}
                end

            else
                # if the current_user's feed is empty (404 not found), we may redirect to and endpoint that returns recommended content and accounts
                render json: {error: "Not Found"}, status: :not_found
            end
        rescue => exception
            # handle user unauthorization. For now we simply return the home page but in later versions recommended content should be returned back to the user
            render '/home/homepage.html.erb', status: 200
        end    
    end

    
end
