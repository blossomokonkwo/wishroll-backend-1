class V2::ActivitiesController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        offset = params[:offset]
        limit = 15
        @activities = Array.new
        if offset
            @activities = current_user.activities.where('created_at < ?', offset).limit(limit).to_a
        else
            @activities = current_user.activities.limit(limit).to_a
        end
        if @activities.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end