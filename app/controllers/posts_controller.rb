class PostsController < ApplicationController
  before_action :authorize_by_access_header!
  #create a post object along with all the tags. Save the post and tags to the DB.
  def create
    @post = Post.new(post_params)
    @post.post_image.attach params[:post_image]
    @post.post_media_url = url_for(@post.post_image)
    @post.user_id = current_user.id
    if @post.save
      render json: nil, status: :ok
    else 
      render json: nil, status: :bad
    end
  end
  
  def show
    #render a specific post to the user along with all the involved tags
    @post = Post.find(params[:id])
    if @post 
      @user = User.find(@post.user_id) #the user that posted the content
      @post.view_count += 1 if current_user.id != @user.id
      @post.save
      render :show, status: 200
    else
      render json: nil, status: 404
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy 
      render json: nil, status: :ok
    else
      render json: {error: "Your post could not be deleted at this time"}, status: 400
    end
  end

  private 
  def post_params
    params.permit :caption, :post_image, :original_post_id
  end
end
