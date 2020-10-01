class V3::Trending::TrendingTagsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        @trending_tags = TrendingTag.order(created_at: :desc).offset(params[:offset]).limit(5).to_a
        if @trending_tags.any?
            @current_user = current_user
            render :index, status: :ok  
        else
            render json: nil, status: :not_found
        end
    end
end