class V2::ViewsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        view = View.new(duration: params[:duration], viewable_id: params[:viewable_id], viewable_type: params[:viewable_type], user_id: current_user.id)
        if view.save
            user = view.viewable.user
            user.view_count += 1
            user.save
            CreateLocationJob.perform_later(params[:ip_address], params[:timezone], view.id, view.class.name)
            render json: nil, status: :created
        else
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