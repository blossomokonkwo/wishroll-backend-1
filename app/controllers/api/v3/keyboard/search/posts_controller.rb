class Api::V3::Keyboard::Search::PostsController < APIController

    def index
        offset = params[:offset]
        limit = 15
        @posts = Post.fetch_multi(Tag.joins(post: {media_item_attachment: :blob}).where("active_storage_blobs.content_type ILIKE ?", "%#{params['content-type']}%").new_search(params[:q]).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}
        if @posts.any?
            #SearchActivitiesJob.perform_now(query: params[:q], user_id: params[:user_id].to_i, content_type: params['content-type'])
            render :index, status: :ok
        else
            #SearchActivitiesJob.perform_now(query: params[:q], user_id: params[:user_id].to_i, content_type: nil)
            render json: nil, status: :not_found
        end
    end
    

end