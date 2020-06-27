class V2::Search::UsersController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        limit = 12
        offset = params[:offset]
        @users = User.where("username ILIKE ? OR name ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").distinct.order(verified: :desc, followers_count: :desc, following_count: :asc, id: :asc).offset(offset).limit(limit)
        @users.to_a.delete_if do |user|
            user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
        end
        if @users.any? 
            @id = current_user.id
            CreateSearchJob.perform_later(:user, params[:q], params[:ip_address], params[:timezone])
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end