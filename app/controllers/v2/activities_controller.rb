class V2::ActivitiesController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        offset = params[:offset]
        limit = 15
        @activities = Array.new
        if offset
            @activities = current_user.activities.order(created_at: :desc).offset(offset).limit(limit)
        else
            @activities = current_user.activities.order(created_at: :desc).limit(limit)
        end
        if @activities.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end