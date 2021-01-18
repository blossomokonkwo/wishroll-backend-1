class Api::V3::Keyboard::Bookmarks::PostsController < APIController
    before_action :authorize_by_access_header!
    def index 
        @posts = current_user.bookmarked_posts(limit: 15, offset: params[:offset]).to_a
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
end