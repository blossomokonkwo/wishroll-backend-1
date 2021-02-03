class Api::V3::Keyboard::Liked::PostsController < APIController
    before_action :authorize_by_access_header!
    
    def index
        @posts = current_user.liked_posts(limit: 15, offset: params[:offset]).to_a
        if @posts.any?
            render :index, status: :ok
        else 
            render json: nil, status: :not_found
        end
    end
end