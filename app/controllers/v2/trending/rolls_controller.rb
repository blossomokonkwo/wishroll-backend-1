class V2::Trending::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def trending
        limit = 15
        @id = current_user.id
        offset = params[:offset] #as the user scrolls the offset is incremented by 100
        @rolls = Roll.includes([:user]).order(created_at: :desc).offset(offset).limit(limit)
        if @rolls.any?
            render :index, status: :ok  
        else
            render json: nil, status: :not_found
        end 
    end
end