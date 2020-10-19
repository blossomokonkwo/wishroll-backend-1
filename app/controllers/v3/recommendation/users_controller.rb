class V3::Recommendation::UsersController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        offset = params[:offset]
        limit = 15
        @users = User.select([:username, :id, :avatar_url, :verified]).where(restricted: false).order(wishroll_score: :desc).limit(limit).to_a
        if @users.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
end