class CommentsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @comment = Comment.new(comment_params)
        @comment.user_id = current_user.id
        if @comment.save
            render json: nil, status: :created
        else
            render json: {error: "Your comment could not be created at this time"}, status: 400
        end
    end

    def show
        #this method ONLY returns a comments replies if any. This method does not return the comment itself.
        #The frontend app is responsible for creating a refrence to the comment and passing it along the views at runtime. 
        @comment = Comment.find(params[:id])
        if @comment.replies_count > 0
            #if a comment has replies, render the jbuilder file that returns an array of all the replies owned by the comment
            render :show, status: :ok
        else
            #if a comment has no replies, render a 404 'not found' status indicating that no replies belong to a the comment
            render json: nil, status: 404
        end
    end

    def index
        #show all the comments relating to a specific post. All the available replies will 
        @comments = Comment.where(post_id: params[:post_id],original_comment_id: nil) #where query is used to find all the rows that match the specified condition(s)
        if @comments.count > 0
            render :index, status: :ok
        else
            render json: nil, status: 404
        end
    end

    def update
        #updates the body of a comment
        @comment = Comment.find(params[:id])
        @comment.update(body: params[:body])
        if @comment.save
            render json: {comment: @comment}, status: :ok
        else
            render json: {error: "There was an error with updating your comment"}
        end
    end

    def destroy
        #deletes a comment from the database table and decrements the comments count for the comments post and its original comment
        @comment = Comment.find(params[:id])
        if @comment.original_comment_id
            original_comment = Comment.find(@comment.original_comment_id)
            original_comment.replies_count -= 1
            original_comment.save
        end
        post = Post.find(@comment.post_id)
        post.number_of_comments -= 1
        post.save
        if @comment.destroy
            render json: nil, status: :ok
        else
            render json: {error: "There was an error with deleting your comment"}, status: 400
        end
    end


    private
    #ensures that a comment is properly created
    def comment_params
        params.permit :body, :post_id, :original_comment_id
    end
    
    
    
    
end
