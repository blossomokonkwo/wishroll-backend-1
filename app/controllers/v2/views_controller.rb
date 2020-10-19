class V2::ViewsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        begin
            view = View.create!(duration: params[:duration], viewable_id: params[:viewable_id], viewable_type: params[:viewable_type], user_id: current_user.id)
            UpdatePopularityRankJob.perform_now(content_id: view.viewable.id, content_type: view.viewable.class.name)
            render json: nil, status: :created            
        rescue => exception
            puts exception
            render json: nil, status: :bad_request
        end
    end

    def index
        offset = params[:offset]
        limit = 25
        if params[:post_id] and post = Post.find(params[:post_id])
            @posts = post.viewed_users(limit: limit, offset: offset)
            if @posts.any?
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:roll_id] and roll = Roll.find(params[:roll_id])
            @users = roll.viewed_users(limit: limit, offset: offset)
            if @users.any? 
                render json: nil, status: :ok
            else
                render json: nil, status: :bad_request
            end
        else
           render json: {error: "No id specified for resource"}, status: :bad_request 
        end
    end
    
end