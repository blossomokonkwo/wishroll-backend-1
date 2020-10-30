class V3::Keyboard::SharesController < ApplicationController 
    def create
        if params[:post_id] and post = Post.find(params[:post_id])
            begin
                share = post.shares.create!(user_id: params[:user_id], shared_service: params[:shared_service])
                ShareActivityJob.perform_now(current_user_id: params[:user_id], share_id: share.id)
                UpdateWishrollScoreJob.perform_now(post.user.id, 3)
                UpdatePopularityRankJob.perform_now(content_id: post.id, content_type: post.class.name)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Could not share the post: #{exception}"}, status: :bad_request
            end
        else
            render json: {error: "Could not locate a resource to complete the operation"}, status: :not_found
        end
    end

end