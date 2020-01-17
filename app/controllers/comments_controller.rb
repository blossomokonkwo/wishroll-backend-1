class CommentsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @comment = Comment.new(comment_params)
        if @comment.save
            render json: {@comment}, status: :created
        else
            render json: {error: "Your comment could not be created at this time"}, status: 400
        end
    end

    def show
        #returns a specific comment
        @ = .find()
    end

    def index
        #show all the comments relating to a specific post. All the available replies will 
        @comments = Comments.find_by(post_id: params[:post_id])
    end

    def update
        #updates the body of a comment
        @comment = Comment.find(params[:comment_id])
        @comment.update(body: params[:body])
        if @comment.save
            render json: {@comment}, status: :ok
        else
            render json: {error: "There was an error with updating your comment"}
        end
    end

    def destroy
        #deletes a comment from the database table 
        @comment = Comment.find(params[:comment_id])
        if @comment.destroy
            render json: {"success" : "Your comment was successfully deleted"}, status: :ok
        else
            render json: {error: "There was an error with deleting your comment"}, status: 400
        end
    end


    private
    #ensures that a comment is properly created
    def comment_params
        params.permit :body, :user_id, :post_id
    end
    
    
    
    
end
