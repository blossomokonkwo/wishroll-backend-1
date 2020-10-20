class V3::Discover::RollsController < ApplicationController
    before_action :authorize_by_access_header!

    def index 
        offset = params[:offset]
        limit = 15
        @rolls = Roll.where(private: false, restricted: false).order(popularity_rank: :desc, created_at: :desc).limit(limit).offset(offset)
        if @rolls.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end