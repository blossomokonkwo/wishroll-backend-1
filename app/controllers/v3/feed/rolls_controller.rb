class V3::Feed::RollsController < ApplicationController
    before_action :authorize_by_access_header!

    def index
        offset = params[:offset]
        limit = 15
        feed_users = current_user.followed_users.to_a
        feed_users << current_user
        @rolls = Roll.includes(:user).where(user: feed_users).order(created_at: :desc).offset(offset).limit(limit).to_a
        if @rolls.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render nil, status: :not_found
        end
    end
    
end