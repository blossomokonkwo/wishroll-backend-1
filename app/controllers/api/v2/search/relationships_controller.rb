class Api::V2::Search::RelationshipsController < APIController
    before_action :authorize_by_access_header!
    def index
        offset = params[:offset]
        limit = 12
        @user = User.fetch(params[:user_id])
        if @user
            if params[:followers] == "true"
                @users = @user.follower_users.where('username ILIKE ? OR name ILIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order(followers_count: :desc, verified: :desc).offset(offset).limit(limit).to_a
            else
                @users = @user.followed_users.where('username ILIKE ? OR name ILIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order(followers_count: :desc, verified: :desc).offset(offset).limit(limit).to_a
            end
            if @users.any?
                @current_user = current_user
                render :index, status: :ok
                SearchActivitiesJob.perform_now(query: params[:q], user_id: current_user.id, content_type: "user")
            else
                render json: nil, status: :not_found
            end
         else
            render json: nil, status: :not_found
         end
    end
    
end