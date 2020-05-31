class V2::Search::UsersController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        @id = current_user.id
        limit = 15
        offset = params[:offset]
        @users = User.where("username ILIKE ? OR name ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").distinct.order(verified: :desc, followers_count: :desc, following_count: :asc, id: :asc).offset(offset).limit(limit)
        @users.to_a.delete_if do |user|
            user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
        end
        if @users.any? 
            CreateSearchJob.perform_now(:user, params[:q], params[:ip_address], params[:timezone])
            render :index, status: 200
        else
            render json: nil, status: 404
        end
    end
    
    
end