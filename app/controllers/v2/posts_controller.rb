class V2::PostsController < ApplicationController
    before_action :authorize_by_access_header!

    def create
      unless !current_user.banned
        begin
          @post = current_user.posts.create!(caption: params[:caption], restricted: current_user.restricted, popularity_rank: 1.0)
          @post.media_item.attach params[:media_item]
          @post.thumbnail_item.attach params[:thumbnail_item] if params[:thumbnail_item]
          @post.media_url = url_for(@post.media_item) if @post.media_item.attached?
          @post.thumbnail_url = url_for(@post.thumbnail_item) if @post.thumbnail_item.attached?
          if @post.save
            render json: {post_id: @post.id}, status: :created
          else 
            render json: nil, status: 400
          end
        rescue => exception
          render json: {error: "An error occured when uploading post #{exception}"}, status: 500
        end
      else
        render json: nil, status: :forbidden
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
      @post = Post.fetch(params[:id])
      @user = @post.fetch_user
      @current_user = current_user
      render :show, status: :ok
      CreateLocationJob.perform_later(params[:ip_address] || request.ip, params[:timezone], @user.id, @user.class.name) if !@user.location
    end
  
    def destroy
      post = Post.find(params[:id])
      if current_user.id == post.user.id || current_user.id == 4
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