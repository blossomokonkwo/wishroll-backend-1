class V2::LikesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:comment_id] and comment = Comment.fetch(params[:comment_id])
            begin
                like = comment.likes.create!(user: current_user)
                LikeActivityJob.perform_now(like_id: like.id)
                UpdateWishrollScoreJob.perform_now(comment.user.id, 1)
                UpdatePopularityRankJob.perform_now(content_id: comment.id, content_type: comment.class.name)           
                render json: nil, status: :created                
            rescue => exception
                render json: {created: "Could not like the comment: #{comment}"}, status: :bad_request
            end
        elsif params[:post_id] and post = Post.fetch(params[:post_id])
            begin
                like = post.likes.create!(user: current_user)
                LikeActivityJob.perform_now(like_id: like.id)
                UpdateWishrollScoreJob.perform_now(post.user.id, 1)
                UpdatePopularityRankJob.perform_now(content_id: post.id, content_type: post.class.name)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Could not like the post: #{post}"}, status: :bad_request
            end
        elsif params[:roll_id] and roll = Roll.fetch(params[:roll_id])
            begin
                like = roll.likes.create!(user: current_user)
                LikeActivityJob.perform_now(like_id: like.id)
                UpdateWishrollScoreJob.perform_now(roll.user.id, 1)
                UpdatePopularityRankJob.perform_now(content_id: roll.id, content_type: roll.class.name)
            rescue => exception 
                render json: {error: "Could not like the roll #{roll}"}, status: :bad_request
            end
        else
            render json: {error: "Could not locate a resource to complete the operation"}, status: :not_found
        end
    end

    def destroy
        like = Like.where(likeable_type: params[:likeable_type], user: current_user, likeable_id: params[:likeable_id]).first
        if like.destroy
            render json: nil, status: :ok
        else
            render json: {error: "An error occured that prevented the like - #{like} - from being destroyed"}, status: 500
        end
    end
    
    # Returns the users that have liked a resource
    def index
        offset = params[:offset]
        limit = 10   
        if params[:post_id] and post = Post.fetch(params[:post_id])
            @users = User.select([:username, :avatar_url, :name, :verified, :id]).joins(:likes).where(likes: {likeable: post}).order('likes.created_at DESC').offset(offset).limit(limit).to_a
            if @users.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:comment_id] and comment = Comment.fetch(params[:comment_id])     
            @users = User.select([:username, :avatar_url, :name, :verified]).joins(:likes).where(likes: {likeable: comment}).order('likes.created_at DESC').offset(offset).limit(limit).to_a
            if @users.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:roll_id] and roll = Roll.fetch(params[:roll_id])
            @users = User.select([:username, :avatar_url, :name, :verified, :id]).joins(:likes).where(likes: {likeable: roll}).order('likes.created_at DESC').offset(offset).limit(limit).to_a
            if @users.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        else
            render json: {error: "Could not locate a resource to complete the operation"}, status: :not_found
        end
    end
end