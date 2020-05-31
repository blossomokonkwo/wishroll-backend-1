class V2::Search::UsersController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        @id = current_user.id
        limit = 15
        offset = params[:offset]
        @users = User.where("username ILIKE ? OR name ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%").distinct.order(verified: :desc, followers_count: :desc, following_count: :asc, id: :asc).offset(offset).limit(limit)
        #filter the returned users to ensure that users who are blocked do not interact with each other
        @users.to_a.delete_if do |user|
            #if a user is blcoked by the current user or the current user is blocked by the other user, then we remove them from the array
            user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
        end
        if @users.any? 
            render :index, status: 200
        else
            render json: nil, status: 404
        end
    end
    
    
end