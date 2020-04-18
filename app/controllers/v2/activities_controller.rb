class V2::ActivitiesController < ApplicationController
    def index
        offset = params[:offset]
        limit = 15
        @activities = Activity.where(user_id: current_user.id).order(created_at: :desc).limit(limit).offset(offset)
        if @activities.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end