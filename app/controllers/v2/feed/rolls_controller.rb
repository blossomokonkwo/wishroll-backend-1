class V2::Feed::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def feed
        offset = params[:offset]
        limit = 25
        @rolls = Roll.where(user: current_user.followed_users).order(created_at: :desc).limit(limit)
        if @rolls.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end