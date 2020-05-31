class V2::Recommendation::PostsController < ApplicationController
    def recommend
        limit = 15
        offset = params[:offset]
        @post = Post.find(params[:id])
        Post.joins(:tags).where("tags.text ILIKE ")
        @posts = Array.new
    end
    
end