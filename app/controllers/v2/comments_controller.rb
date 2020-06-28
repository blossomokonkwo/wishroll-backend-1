class V2::CommentsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            begin
                @comment = roll.comments.create!(body: params[:body], original_comment_id: params[:original_comment_id], user: current_user)
                @user = current_user
                if !current_user.rolls.include?(roll)
                    activity_phrase = nil
                    user_id = nil
                    if @comment.original_comment_id
                        user_id = Comment.find(params[:original_comment_id]).user_id
                        activity_phrase = "#{current_user.username} replied to to your comment"
                    else
                        user_id = roll.user_id
                        activity_phrase = "#{current_user.username} commented on your post"
                    end
                    activity = Activity.new(user_id: user_id, active_user_id: current_user.id, activity_phrase: activity_phrase, activity_type: @comment.class.name, content_id: @comment.id, media_url: roll.thumbnail_url)
                    activity.save
                end
                render :create, status: :created
            rescue => exception
                render json: {error: "Couldn't create comment for roll #{roll}"}, status: 500
            end
        elsif params[:post_id] and post = Post.find(params[:post_id])
            begin
                @comment = post.comments.create!(body: params[:body], user_id: current_user.id, original_comment_id: params[:original_comment_id])
                @user = current_user
                if !current_user.posts.include?(roll)
                    activity_phrase = nil
                    user_id = nil
                    if @comment.original_comment_id
                        user_id = Comment.find(params[:original_comment_id]).user_id
                        activity_phrase = "#{current_user.username} replied to to your comment"
                    else
                        user_id = post.user_id
                        activity_phrase = "#{current_user.username} commented on your post"
                    end
                    activity = Activity.new(user_id: user_id, active_user_id: current_user.id, activity_phrase: activity_phrase, activity_type: @comment.class.name, content_id: @comment.id, media_url: post.thumbnail_url != nil ? post.thumbnail_url : post.media_url)
                    activity.save
                end
                render :create, status: :created
            rescue => exception
                puts comment.errors.inspect
                render json: {error: "Couldn't create comment for post #{post}", messages: comment.errors}, status: 500
            end
        else
            render json: {error: "Couldn't find resource "}, status: :not_found
        end
    end

    def update
        @comment = Comment.find(params[:id])
        @comment.update_attributes(body: params[:body])
        if @comment.save
            render :show, status: :ok
        else
            render json: {error: "Could not update comment with body #{params[:body]}"}, status: 500         
        end
    end
    
    def index
        limit = 15
        offset = params[:offset]
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            @comments = roll.comments.order(created_at: :asc).offset(offset).limit(limit)
            if @comments.any?
                @id = current_user.id
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:post_id] and post = Post.find(params[:post_id])
            @comments = post.comments.order(created_at: :asc).offset(offset).limit(limit)
            if @comments.any?
                @id = current_user.id
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        else
            render json: {error: "Couldn't locate parent resource"}, status: :not_found
        end
    end
    
    def show
        @comment = Comment.find(params[:id])
        @replies = @comment.replies.includes(:user)
        if @replies.any?
            render :show, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    

    def destroy        
        @comment = Comment.find(params[:id])
        if @comment.destroy
            render json: nil, status: :ok
        else
            render json: {error: "There was an error with deleting your comment"}, status: 500
        end
    end

    # private 
    # def create_params
    #     params.permit :orignal_post_id, :body, :post_id, :roll_id, :user_id
    # end
    
    
end