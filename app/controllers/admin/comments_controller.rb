module Admin
    class CommentsController < Admin::BaseController 
        def show
            @comment = Comment.find(params[:id])
            render :show, status: :ok
        end

        def index
            @comments = Post.find(params[:post_id]).comments
            if @comments
                render :index, status: :ok
            else
                render json: {error: "There are no comments for this post"}, status: 400
            end
        end

        def destroy
            @comment = Comment.find(params[:id])
            if @comment.destroy
                render json: nil, status: :ok
            else
                render json: {error: "Could not delete comment"}, status: 400
            end
        end
    end
end