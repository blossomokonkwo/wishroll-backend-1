class V2::BookmarksController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:post_id] and post = Post.find(params[:post_id])
            begin 
                bookmark = post.bookmarks.create!(user: current_user)
                UpdateWishrollScoreJob.perform_now(post.user.id, 2)
                UpdatePopularityRankJob.perform_now(content_id: post.id, content_type: post.class.name)
                render json: nil, status: :created
            rescue
                render json: {error: "Couldn't create bookmark for post #{post.inspect}"}, status: 500
            end
        else
            render json: {error: "Couldn't find resource"}, status: :not_found
        end
    end
    
    def bookmarked_users
        offset = params[:offset]
        limit = 15
        if params[:post_id] and post = Post.find(params[:post_id])
            @users = User.joins([:bookmarks]).where(bookmarks: {bookmarkable: post}).order("bookmarks.created_at DESC").offset(offset).limit(limit).to_a
            if @users.any?
                @current_user = current_user
                render :index_users, status: :ok
            else
                render json: nil, status: :not_found
            end
        else
            render json: {error: "Roll not found with id #{params[:roll_id]}"}, status: :not_found
        end
    end

    def index
        offset = params[:offset]
        limit = 18 
        user = User.fetch(params[:user_id])
        unless user.blocked?(current_user) || current_user.blocked?(user)
            @posts = user.bookmarked_posts(limit: limit, offset: offset).to_a
            if @posts.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        else
            render json: nil, status: :forbidden
        end
    end

    def bookmarked_rolls
        render json: nil, status: :not_found
    end

    def destroy
        if params[:post_id] and post = Post.find(params[:post_id])
            if post.bookmarks.find_by(user: current_user).destroy
                render json: nil, status: :ok
            else
                render json: {error: "Couldn't destroy the bookmark"}, status: 500
            end
        end
    end
    
end
