class V3::Discover::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        offset = params[:offset] || 0
        limit = 15
        @rolls = Roll.where(featured: true).order(popularity_rank: :desc).limit(limit).offset(offset).to_a.shuffle!
        if @rolls.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render nil, status: :not_found
        end
    end
    
end