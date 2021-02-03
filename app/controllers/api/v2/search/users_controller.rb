class Api::V2::Search::UsersController < APIController
    def index
        limit = 12
        offset = params[:offset]
        @users = User.select([:username, :id, :name, :verified, :followers_count, :avatar_url]).where("username ILIKE ? OR name ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").order(verified: :desc, followers_count: :desc).offset(offset).limit(limit).to_a
        
        begin
            # fetch the access tokens from the request header
            authorize_by_access_header!
            
            @current_user = current_user
        rescue => exception
            # handle unauthorization actions
            puts exception
        end

        if @users.any?
            render :index, status: :ok
        else 
            render json: nil, status: :not_found
        end

    end
    
    
end