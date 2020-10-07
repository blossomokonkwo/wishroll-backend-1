class V3::Keyboard::Trending::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        offset = params[:offset]
        limit = 15
        content_type = params[:content_type]
        #for now return only WishRoll's posts to the keyboard. Later on when a reccomender system is established, recommended posts will be returned instead
        @posts = User.fetch(4).posts.joins(media_item_attachment: :blob).where('active_storage_blobs.content_type ILIKE ?', "%#{content_type}%").offset(offset).limit(limit).to_a
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end