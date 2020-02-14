class SearchController < ApplicationController
    before_action :authorize_by_access_header!
    def search 
        @id = current_user.id
        @posts = Array.new
        @users = Array.new
        if !params[:query].empty?
            @users = User.where("username ILIKE ?", "#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc) 
            .or(User.where("first_name ILIKE ?", "#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc) 
            .or(User.where("last_name ILIKE ?", "#{search_params[:query]}%").order(is_verified: :desc, followers_count: :desc, following_count: :asc)))      
            Tag.where("text ILIKE ?", "#{search_params[:query]}%").limit(1000).includes([:post]).find_each do |tag|
                @posts << tag.post
            end
            if @posts.empty? and @users.empty?
                render json: nil, status: 404
            else
                #puts "These are the users #{@users.first.birth_date}\n\n\n\n\n\n\n"
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
