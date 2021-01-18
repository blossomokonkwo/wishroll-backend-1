class Api::V3::Discover::RollsController < APIController
    before_action :authorize_by_access_header!

    def index 
        if params[:should_fetch]
            offset = params[:offset]
            limit = 15
            @rolls = Roll.select([:caption, :id, :media_url, :thumbnail_url, :popularity_rank, :likes_count, :comments_count, :share_count, :bookmark_count, :view_count, :created_at, :updated_at, :private, :restricted, :uuid, :user_id])
            .where(private: false, restricted: false)
            .order(popularity_rank: :desc, created_at: :desc)
            .limit(limit)
            .offset(offset)
            if @rolls.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        else
            render json: nil, status: :not_found
        end
    end
    
end