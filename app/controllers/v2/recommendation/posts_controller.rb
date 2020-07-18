class V2::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        limit = 15
        offset = params[:offset]
        @post = Post.fetch(params[:post_id])
        keywords = Array.new
        english_articles = ["the", "a", "when" "some", "they", "back", "because", "if", "in"]
        @post.fetch_tags.pluck(:text).map {|word| word.split(' ').delete_if {|word| english_articles.include?(word)}.map {|t| keywords << "%#{t}%"}}
        caption_terms = @post.caption.split(' ').delete_if {|word| english_articles.include?(word)}.map {|word| keywords << "%#{word}%"}
        @posts = Post.joins(:tags).where("tags.text ILIKE ANY (array[?]) OR posts.caption ILIKE ANY (array[?])", keywords, keywords).distinct.includes([user: :blocked_users]).order(likes_count: :desc, view_count: :desc, id: :asc).offset(offset).limit(limit).to_a
        @posts.delete_if do |p|
            p.id == @post.id or p.user.blocked?(current_user) or current_user.blocked?(p.user)
        end
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end