class V2::Trending::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def trending
        limit = 12
        offset = params[:offset]
        @rolls = Roll.includes([:user]).order(popularity_rank: :desc).offset(offset).limit(limit)
        if @rolls.any?
            @current_user = current_user
            render :index, status: :ok  
        else
            render json: nil, status: :not_found
        end 
    end
end