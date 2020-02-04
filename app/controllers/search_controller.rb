class SearchController < ApplicationController
    before_action :authorize_by_access_header!
    def search 
        @id = current_user.id
        @posts = Array.new
        @users = Array.new
        if params[:query_type] == "User"
            @users = User.where("username ILIKE ?", "#{search_params[:query]}%")
            .or(User.where("first_name ILIKE ?", "#{search_params[:query]}%"))
            .or(User.where("last_name ILIKE ?", "#{search_params[:query]}%"))
        else
            Tag.where("text ILIKE ?", "#{search_params[:query]}%").limit(500).includes([:post]).find_each do |tag|
                @posts << tag.post
            end
        end
        if @posts.empty? and @users.empty?
            render json: nil, status: 404
        else
            render :index, status: :ok
        end
    end


    private 
    def search_params
        params.permit :query
    end
end
