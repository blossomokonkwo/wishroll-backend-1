class V2::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        limit = 15
        offset = params[:offset]
        @post = Post.fetch(params[:post_id])
        keywords = String.new
        english_articles = ["the", "a", "when" "some", "they", "back", "because", "if", "in"]
        @post.fetch_tags.pluck(:text).map {|word| word.split(' ').delete_if {|word| english_articles.include?(word)}.map {|t| keywords << "#{t} "}}
        caption_terms = @post.caption.split(' ').delete_if {|word| english_articles.include?(word)}.map {|word| keywords << "#{word} "}
        @posts = Post.fetch_multi(Tag.search(keywords).limit(limit).offset(offset).pluck(:post_id)).uniq!
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end