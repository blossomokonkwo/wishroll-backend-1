class V2::CommentsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            begin
                roll.comments.create!(body: params[:body], original_comment_id: params[:original_comment_id], user: current_user)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Couldn't create comment for roll #{roll}"}, status: 500
            end
        elsif params[:post_id] and post = Post.find(params[:post_id])
            begin
                @comment = post.comments.create!(body: params[:body], user_id: current_user.id, original_comment_id: params[:original_comment_id])
                @user = current_user
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
        limit = 25
        offset = params[:offset]
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            @comments = roll.comments.order(likes_count: :desc, created_at: :desc)
            if @comments.any?
                @id = current_user.id
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:post_id] and post = Post.find(params[:post_id])
            @comments = post.comments.order(likes_count: :desc, created_at: :desc)
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