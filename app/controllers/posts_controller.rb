class PostsController < ApplicationController
  before_action :authorize_by_access_header!
  #create a post object along with all the tags. Save the post and tags to the DB.
  def create
    @post = Post.create(caption: params[:caption], user_id: current_user.id, original_post_id: params[:original_post_id])
    @post.post_image.attach params[:post_image]
    @post.posts_media_url = url_for(@post.post_image)
    if @post.save
      render json: {post_id: @post.id}, status: :ok
    else 
      render json: nil, status: :bad
    end
  end
  
  def show
    #render a specific post to the user along with all the involved tags
    @post = Post.find(params[:id])
    if @post 
      @user = @post.user
      if current_user.blocked_users.include?(@user) or @user.blocked_users.include?(current_user)
          render json: nil, status: 403 #user is blocked therefore he is forbidden
      else
        @id = current_user.id #the user that posted the content
        if @id != @user.id
            @post.view_count += 1
            @user.total_view_count += 1
            @user.save 
            @post.save
          render :show, status: 200
        else
          render json: nil, status: 404
        end
      end
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
end
