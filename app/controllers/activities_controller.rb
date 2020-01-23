class ActivitiesController < ApplicationController
  before_action :authorize_by_access_header!
  def index
    #returns all of the activities affecting the user referenced by the user_id field
    @activities = Activity.where(user_id: params[:user_id])
    if @activities
      render :index, status: 200
    else
      render json: nil, status: 404
    end
  end
end
