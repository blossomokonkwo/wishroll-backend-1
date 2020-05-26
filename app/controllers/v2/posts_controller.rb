class V2::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    #create a post object along with all the tags. Save the post and tags to the DB.
    def create
      @post = Post.create(caption: params[:caption], user_id: current_user.id, original_post_id: params[:original_post_id])
      @post.post_image.attach params[:post_image]
      @post.media_url = url_for(@post.post_image)
      if params[:thumbnail_image]
        @post.thumbnail_image.attach params[:thumbnail_image]
        @post.thumbnail_url = url_for(@post.thumbnail_image)
      end
      if @post.save
        render json: {post_id: @post.id}, status: :ok
      else 
        render json: nil, status: :bad
      end
    end

    def update
      @post = Post.find(params[:id])
      if @post.user.id == current_user.id
        if @post.update(update_params)
          render :update, status: :ok
        else 
          render json: {error: "Could not update Post: #{@post}"}, status: :bad_request
        end
      else
        render json: {error: "Only the creator of the post: #{@post} can update its attributes"}, status: :bad_request
      end
    end
    
    
    def show
        @post = Post.find(params[:id]) 
        @user = @post.user
        @id = current_user.id
        render :show, status: :ok
    end
  
    def destroy
      post = Post.find(params[:id])
      if current_user.id == post.user.id
        if post.destroy 
          render json: nil, status: :ok
        else
          render json: {error: "Post could not be deleted at this time"}, status: 500
        end
      else
        render json: {error: "Cannot destroy post because post creator is not the same as post destroyer"}, status: :forbidden
      end
    end 
    
    private 
    def update_params
      params.permit :caption, :tags
    end
    
    
end