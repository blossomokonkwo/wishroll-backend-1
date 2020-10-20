class V2::Trending::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def trending 
        #the number of posts that are sent to the users feed page. The feed sends the most popular posts
        limit = 18
        offset = params[:offset]
        @posts = Post.where(restricted: false).order(popularity_rank: :desc).offset(offset).limit(limit).to_a.shuffle!
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok 
            CreateLocationJob.perform_later(params[:ip_address] || request.ip, params[:timezone], current_user.id, current_user.class.name) if !current_user.location
        else
            render json: nil, status: :not_found
        end
    end
end