class V3::Trending::TrendingTagsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        @trending_tags = TrendingTag.order(created_at: :desc).offset(params[:offset]).limit(5).to_a
        if @trending_tags.any?
            @current_user = current_user
            render :index, status: :ok
            CreateLocationJob.perform_now(params[:ip_address] || request.ip, params[:timezone], current_user.id, current_user.class.name) if !current_user.location
        else
            render json: nil, status: :not_found
        end
    end

    def show
        @trending_tag = TrendingTag.find(params[:id])
        @posts = @trending_tag.posts(offset: params[:offset], limit: 18).to_a
        if @posts.any?
            @current_user = current_user
            render :show, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end