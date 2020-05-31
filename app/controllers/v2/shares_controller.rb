class V2::SharesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            begin
                share = roll.shares.create!(user: current_user, shared_service: params[:shared_service])
                CreateLocationJob.perform_now(params[:ip_address], params[:timezone], share.id, share.class.name)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Could not share the roll: #{roll.errors.inspect}"}, status: :bad_request
            end            
        elsif params[:post_id] and post = Post.find(params[:post_id])
            begin
                share = post.shares.create!(user: current_user, shared_service: params[:shared_service])
                CreateLocationJob.perform_now(params[:ip_address], params[:timezone], share.id, share.class.name)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Could not share the post: #{post}"}, status: :bad_request
            end
        else
            render json: {error: "Could not locate a resource to complete the operation"}, status: :not_found
        end
    end

    def index
        
    end
    
    
end