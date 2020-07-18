class V2::Search::UsersController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        limit = 12
        offset = params[:offset]
        @users = User.where("username ILIKE ? AND name ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").order(verified: :desc, followers_count: :desc).offset(offset).limit(limit)
        if @users.any? 
            @id = current_user.id
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end