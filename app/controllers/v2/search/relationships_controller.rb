class V2::Search::RelationshipsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        offset = params[:offset]
        limit = 12
        if params[:followers]
            @users = current_user.follower_users.where('username ILIKE ? OR name ILIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order(followers_count: :desc, verified: :desc).offset(offset).limit(limit)
        else
            @users = current_user.followed_users.where('username ILIKE ? OR name ILIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order(followers_count: :desc, verified: :desc).offset(offset).limit(limit)
        end
        if @users.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end