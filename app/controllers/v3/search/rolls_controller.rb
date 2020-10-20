class V3::Search::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        offset = params[:offset]
        limit = 15
        @rolls = Roll.fetch_multi(HashTag.search(params[:q]).limit(limit).offset(offset).pluck(:id)).uniq {|p| p.id}
        if @rolls.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
end