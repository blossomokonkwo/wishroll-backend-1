class V2::Search::RollsController < ApplicationController
    before_action :authorize_by_access_header!
    def search
        @id = current_user.id
        limit = 15
        offset = params[:offset]
        @rolls = Roll.left_outer_joins(:tag).where("text ILIKE ?", "%#{params[:q]}%").includes([user: [:blocked_users]], :views, :likes).distinct.order(likes_count: :desc, view_count: :desc, created_at: :desc, id: :asc).offset(offset).limit(limit)
        @rolls.to_a.delete_if do |roll|
            current_user.reported_posts.include?(roll) or current_user.blocked_users.include?(roll.user) or roll.user.blocked_users.include?(current_user)
        end
        if @rolls.any?
            render :index, status: 200
        else
            render json: nil, status: 404
        end
    end
    

end