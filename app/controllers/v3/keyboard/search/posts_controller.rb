class V3::Keyboard::Search::PostsController

    def index
        @posts = Post.fetch_multi(Tag.new_search(params[:q]).offset(params[:offset]).limit(15).pluck(:post_id)).uniq {|p| p.id}
        if @posts.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    

end