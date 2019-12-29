class PostsController < ApplicationController
  before_action :authorize_by_access_header!
  #create a post object along with all the tags. Save the post and tags to the DB.
  def create
    @post = Post.new(post_params)
    @post.post_image.attach params[:post_image]
    @post.user_id = current_user.id
    if @post.save
      render json: {post_id: @post.id, image_url: url_for(@post.post_image)}, status: :ok
    else render @post.errors.messages, status: :bad
    end
  end
  #render a specific post to the user along with all the involved tags
  def show
    @post = Post.find(params[:post_id])
    @post.view_count += 1 if current_user.email != User.find(@post.user_id).email
    @post.save
    if @post
      user_tags = Array.new
      if @post.tags.count > 0
        tags = @post.tags 
        for tag in tags
          tag_hash = {id: tag.id, text: tag.text}
          user_tags << tag_hash
        end
    end
      post_image = @post.post_image if @post.post_image.attached?
      render json: {post: {id: @post.id ,user_id: @post.user_id, view_count: @post.view_count, caption: @post.caption, created_at: @post.created_at, image_url: url_for(post_image)},tags: user_tags}, status: :ok
    else
      render text: "No such posts", status: :bad
    end
  end
  # returns all the posts made by a specific user
  def index
    user = User.find_by(email: params[:email])
    @posts = user.posts
    if @posts.count > 0 
      posts = Array.new
      user_tags = Array.new
      for post in @posts
        post_image = post.post_image if post.post_image.attached?
        if post.tags.count > 0
          tags = post.tags 
          for tag in tags
            tag_hash = {id: tag.id, text: tag.text}
            user_tags << tag_hash
          end
      end
        post_hash = {post_id: post.id, caption: post.caption, created_at: post.created_at, view_count: post.view_count, image_url: url_for(post_image), tags: user_tags}
        posts << post_hash
      end
      render json: {posts: posts}, status: :ok
    else 
      render text: "You have no posts"
    end
  end
  def destroy
    @post = Post.find(params[:post_id])
    if @post.destroy 
      render text: "Your post has been deleted", status: :ok
    else
      render json: {error: @post.error.messages}, status: :bad
    end
  end
  private 
  def post_params
    params.permit :caption, :post_image
  end
end
