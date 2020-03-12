class SearchController < ApplicationController
    before_action :authorize_by_access_header!
    def search 
        @id = current_user.id
        @posts = Array.new #we want a collection of UNIQUE posts sent to the clients, therfore we are using the Set Abstract Data Type
        @users = Array.new
        if !params[:query].empty?
            @users = User.where("username ILIKE ?", "#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc).select([:username, :is_verified, :full_name, :profile_picture_url]) 
            .or(User.where("full_name ILIKE ?", "%#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc).select([:username, :is_verified, :full_name, :profile_picture_url]))     
            Tag.where("text ILIKE ?", "%#{search_params[:query]}%").limit(5000).includes([:post]).find_each do |tag|
                @posts << tag.post
            end
            if @posts.empty? and @users.empty?
                render json: nil, status: 404
            else
                @users.to_a.keep_if do |user|
                    !(current_user.blocked_users.include?(user)) and !(user.blocked_users.include?(current_user))
                end
                render :index, status: :ok
            end
        else
            render json: nil, status: 404
        end
    end


    private 
    def search_params
        params.permit :query, :query_type
    end
end
