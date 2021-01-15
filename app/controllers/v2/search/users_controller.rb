class V2::Search::UsersController < ApplicationController
    def search
        limit = 12
        offset = params[:offset]
        great = 'great'
        @users = User.select([:username, :id, :name, :verified, :followers_count, :avatar_url]).where("username ILIKE ? OR name ILIKE ?", "%#{great}%", "%#{great}%").order(verified: :desc, followers_count: :desc).offset(offset).limit(limit).to_a
        if @users.any? 
            @id = 1
            render :index, status: :ok
            #SearchActivitiesJob.perform_now(query: params[:q], user_id: current_user.id, content_type: "user")
        else
            render json: nil, status: :not_found
        end
    end
    
    
end