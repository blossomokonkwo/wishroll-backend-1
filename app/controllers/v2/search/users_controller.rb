class V2::Search::UsersController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        limit = 12
        offset = params[:offset]
        @users = User.select([:username, :id, :name, :verified, :followers_count, :avatar_url]).where("username ILIKE ? OR name ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").order(verified: :desc, followers_count: :desc).offset(offset).limit(limit).to_a
        if @users.any? 
            @id = current_user.id
            render :index, status: :ok
            SearchActivitiesJob.perform_now(query: params[:q], user_id: current_user.id, content_type: "user")
        else
            render json: nil, status: :not_found
        end
    end
    
    
end