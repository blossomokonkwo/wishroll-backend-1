class V2::BookmarksController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            begin
                bookmark = roll.bookmarks.create!(user: current_user)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Couldn't create bookmark for roll #{roll.inspect}"}, status: 500
            end
            elsif params[:post_id] and post = Post.find(params[:post_id])
                begin 
                    bookmark = post.bookmarks.create!(user: current_user)
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
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            @users = User.joins([:bookmarks]).where(bookmarks: {bookmarkable: roll}).order("bookmarks.created_at DESC").offset(offset).limit(limit)
            if @users.any?
                @users.to_a.delete_if do |user|
                    user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
                end
                render :index_users, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:post_id] and post = Post.find(params[:post_id])
            @users = User.joins([:bookmarks]).where(bookmarks: {bookmarkable: post}).order("bookmarks.created_at DESC").offset(offset).limit(limit)
            if @users.any?
                @users.to_a.delete_if do |user|
                    user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
                end
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
        limit = 15 
        @posts = current_user.bookmarked_posts(limit: limit, offset: offset)
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def bookmarked_rolls
        offset = params[:offset]
        limit = 15
        @rolls = current_user.bookmarked_rolls(limit: limit, offset: offset)
        if @rolls.any?
            render :bookmarked_rolls, status: :ok
        else 
            render json: nil, status: :not_found
        end
    end

    def destroy
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            if roll.bookmarks.find_by(user: current_user).destroy 
            render json: nil, status: :ok
            else
                render json: {error: "Couldn't destroy the bookmark"}, status: 500
            end
        elsif params[:post_id] and post = Post.find(params[:post_id])
            if post.bookmarks.find_by(user: current_user).destroy
                render json: nil, status: :ok
            else
                render json: {error: "Couldn't destroy the bookmark"}, status: 500
            end
        end
    end
    
end
