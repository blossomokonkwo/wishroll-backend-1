class Api::V2::CommentsController < APIController
    before_action :authorize_by_access_header!
    def create
        if params[:post_id] and post = Post.fetch(params[:post_id])
            begin
                @comment = post.comments.create!(body: params[:body], user_id: current_user.id, original_comment_id: params[:original_comment_id])
                @user = current_user
                CommentActivityJob.perform_now(@comment.id, current_user.id)
                render :create, status: :created
            rescue => exception
                render json: {error: "Couldn't create comment for post #{post}", messages: exception}, status: 500
            end
        elsif params[:roll_id] and roll = Roll.fetch(params[:roll_id])
            begin
                @comment = roll.comments.create!(body: params[:body], user_id: current_user.id, original_comment_id: params[:original_comment_id])
                @user = current_user
                CommentActivityJob.perform_now(@comment.id, current_user.id)
            rescue => exception
                puts exception
                render json: {error: "Couldn't create comment for roll #{roll}", messages: exception}, status: 500
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
        offset = params[:offset]
        limit = 15
        if params[:post_id] and post = Post.fetch(params[:post_id])
            @comments = post.comments.includes([:user]).where.not(user: current_user.blocked_users).where.not(user: current_user.blocker_users).offset(offset).limit(limit).order(created_at: :asc).to_a
            if @comments.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:roll_id] and roll = Roll.fetch(params[:roll_id])
            @comments = roll.comments.offset(offset).limit(limit).order(created_at: :asc).to_a
            if @comments.any?
                @current_user = current_user
                render :index, status: :ok
            else 
                render json: nil, status: :not_found
            end
        else
            render json: nil, status: :not_found
        end
    end
    
    def show
        render json: nil, status: :not_found
    end
    

    def destroy        
        @comment = Comment.find(params[:id])
        if @comment.destroy
            render json: nil, status: :ok
        else
            render json: {error: "There was an error with deleting your comment"}, status: 500
        end
    end
end