class Api::V2::Search::PostsController < APIController

    def index
        limit = 18
        offset = params[:offset]
        @posts = Post.fetch_multi(Tag.search(params[:q]).offset(offset).limit(limit).pluck(:post_id)).uniq {|p| p.id}
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end