class PostsController < ApplicationController
  before_action :authorize_by_access_header!, only: [:create, :destroy]
  #create a post object along with all the tags. Save the post and tags to the DB.
  def create
    @post = Post.create(caption: params[:caption], user_id: current_user.id)
    @post.media_item.attach params[:post_image]
    @post.media_url = url_for(@post.media_item)
    if @post.save
      render json: {post_id: @post.id}, status: :ok
    else 
      render json: nil, status: :bad
    end
  end
  
  def show

    # ensure that the post is found
    if @post = Post.fetch(params[:id]) 
      @user = @post.user
      begin
        # fetch the access tokens from the request header
        authorize_by_access_header!

        # perfom any actions that require an authorized user

        unless current_user == @user

          unless current_user.blocked?(@user) or @user.blocked?(current_user)
            @following = current_user.following?(@user)
          else

            # handle a forbidden response due to blocked accounts
            respond_to do |format|
              format.html {render html: "Blocked yo ass", status: :forbidden}
              format.json {render json: {error: "Blocked", status: :forbidden}}
            end

          end
        end  
        @current_user = current_user
      rescue => exception
        # handle any actions needed for an anauthorized user  
      end

      # handle a 200 ok response based on request format
      respond_to do |format|
        format.html {render :show, status: :ok}
        format.json {render :show, status: :ok}
      end

    else 

      # handle not found response
      respond_to do |format|
        format.html {render html: "Post Not Found", status: :not_found}
        format.json {render json: "Not Found", status: :not_found}
      end

    end

  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy 
      render json: nil, status: :ok
    else
      render json: {error: "Post Couldn't be deleted"}, status: 400
    end
  end
end
