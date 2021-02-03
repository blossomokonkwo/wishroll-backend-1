class Api::V2::SharesController < APIController
    before_action :authorize_by_access_header!
    def create
        if params[:post_id] and post = Post.find(params[:post_id])
            begin
                share = post.shares.create!(user: current_user, shared_service: params[:shared_service])
                ShareActivityJob.perform_now(current_user_id: current_user.id, share_id: share.id)
                UpdateWishrollScoreJob.perform_now(post.user.id, 3)
                UpdatePopularityRankJob.perform_now(content_id: post.id, content_type: post.class.name)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Could not share the post: #{post}"}, status: :bad_request
            end
        elsif params[:roll_id] and roll = Roll.fetch(params[:roll_id])
            begin
                share = roll.shares.create!(user: current_user, shared_service: params[:shared_service])
                ShareActivityJob.perform_now(current_user_id: current_user.id, share_id: share.id)
                UpdateWishrollScoreJob.perform_now(roll.user.id, 3)
                UpdatePopularityRankJob.perform_now(content_id: roll.id, content_type: roll.class.name)
            rescue => exception
                puts exception
                render json: {error: "Could not share the roll: #{roll}"}, status: :bad_request
            end
        else
            render json: {error: "Could not locate a resource to complete the operation"}, status: :not_found
        end
    end

    def users
        offset = params[:offset]
        limit = 10
        if params[:post_id] and post = Post.find(params[:post_id])
            @users = User.select([:username, :avatar_url, :name, :verified, :id]).joins(:shares).where(shares: {shareable: post}).order("shares.created_at DESC").offset(offset).limit(limit).to_a
            if @users.any?
                @current_user = current_user
                render :users, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:roll_id] and roll = Roll.fetch(params[:roll_id])
            @users = User.select([:username, :avatar_url, :name, :verified, :id]).joins(:shares).where(shares: {shareable: roll}).order("shares.created_at DESC").offset(offset).limit(limit).to_a
            if @users.any?
                @current_user = current_user
                render :users, status: :ok
            else 
                render json: nil, status: :not_found
            end
        else
            render json: {error: "Content Could not be found"}, status: 500
        end 
    end
    
    
end