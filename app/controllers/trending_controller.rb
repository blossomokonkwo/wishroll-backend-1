class TrendingController < ApplicationController
    before_action :authorize_by_access_header!
    def trending 
        #the number of posts that are sent to the users feed page. The feed sends the most popular posts
        @num_trending_posts = 15
        @id = current_user.id
        offset = params[:offset] #as the user scrolls the offset is incremented by 100
        @posts = Post.order(view_count: :desc).offset(offset).limit(@num_trending_posts)
        render :index, status: :ok  
    end
end
