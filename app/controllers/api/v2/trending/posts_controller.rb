class Api::V2::Trending::PostsController < APIController

    def index 
        limit = 18
        offset = params[:offset]
        @posts = Post.where(restricted: false).order(popularity_rank: :desc).offset(offset).limit(limit).to_a
        if @posts.any?
            begin
                # fetch the access tokens from the HTTP header hash
                authorize_by_access_header!
                
                @current_user = current_user
            rescue => exception
                # handle any actions needed for an unauthorized user
            end
            render :index, status: :ok             
        else
            render json: nil, status: :not_found
        end
    end
end