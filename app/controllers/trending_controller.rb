class TrendingController < ApplicationController
    before_action :authorize_by_access_header!
    def trending 
        #the number of posts that are sent to the users feed page. The feed sends the most popular posts
        @num_trending_posts = 333 
        posts = Post.order(view_count: :desc).first(@num_trending_posts)
        @posts = Array.new
        posts.each do |p|
            post = Hash.new
            post[:id] = p.id
            post[:caption] = p.caption
            post[:created_at] = p.created_at
            post[:view_count] = p.view_count
            post[:image_url] = p.posts_media_url
            @posts << post
        end
        render json: @posts, status: :ok  
    end
end
