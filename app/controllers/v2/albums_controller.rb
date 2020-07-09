class V2::AlbumsController < ApplicationController
   before_action :authorize_by_access_header!
   def create
    begin
        @album = current_user.albums.create!(name: params[:name], private: params[:private])
        if @album
            render json: @album.to_json, status: :created
        else
            render json: {error: "The current users album couldn't be created"}, status: 500
        end
    rescue
        render json: {error: "An error occured that prevented the album from being created"}, status: 500
    end
   end
   
  def update
      @album = current_user.albums.find(params[:id])
      params[:post_ids].each do |post_id|
          @album.posts << Post.find(params[:post_id])
      end
      @album.thumbnail_url = @album.posts.last.thumbnail_url ? @album.posts.last.thumbnail_url : @album.posts.last.media_url
      if params[:name]
        @album.name = params[:name]
      end      
      if @album.save
        render @album.to_json, status: :ok
      else
        render json: nil, status: 500
      end
  end
  

  def destroy
    album = Album.find(params[:id])
    if album.destroy
        render json: nil, status: :ok
    else
        render json: nil, status: 500
    end
  end
  
  def index
    limit = 15
    offset = params[:offset]
    @albums = Array.new
    @user = User.find(params[:user_id])
    if current_user == @user
        @albums = @user.albums.order(created_at: :desc).offset(offset).limit(limit)
    else
        @albums = @user.albums.where(private: false).order(created_at: :desc).offset(offset).limit(limit)
    end
    if @albums.any?
        @current_user = current_user
        render :index, status: :ok
    else
        render json: nil, status: :not_found
    end
  end

  def show
    offset = params[:offset]
    limit = 15
    @posts = Album.find(params[:id]).posts.offset(offset).limit(limit)
    if @posts.any?
        @current_user = current_user
        render :show, status: :ok
    else
        render json: nil, status: :not_found
    end
  end
  
  
    
end
