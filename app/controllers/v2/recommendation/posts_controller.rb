class V2::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        limit = 15
        offset = params[:offset]
        @id = current_user.id
        @post = Post.find(params[:post_id])
        keywords = Array.new
        english_articles = ["the", "a", "when" "some", "they", "back", "because", "if", "in"]
        @post.tags.pluck(:text).map {|word| word.split(' ').delete_if {|word| english_articles.include?(word)}.map {|t| keywords << "%#{t}%"}}
        caption_terms = @post.caption.split(' ').delete_if {|word| english_articles.include?(word)}.map {|word| keywords << "%#{word}%"}
        @posts = Array.new
        if @post.media_url.end_with?("mov") || @post.media_url.end_with?("mp4") || @post.media_url.end_with?("m4v") || @post.media_url.end_with?("flv")
            video_formats = ["mov%", "mp4%", "m4v%", "flv%"]
            @posts = Post.joins(:tags).where("posts.media_url LIKE ANY (array[?])", video_formats).where("tags.text ILIKE ANY (array[?]) or posts.caption ILIKE ANY (array[?])",keywords, keywords).distinct.includes([user: :blocked_users]).order(likes_count: :desc, view_count: :desc, id: :asc).offset(offset).limit(limit).to_a
        else
            @posts = Post.joins(:tags).where("tags.text ILIKE ANY (array[?]) or posts.caption ILIKE ANY (array[?])",keywords, keywords).distinct.includes([user: :blocked_users]).order(likes_count: :desc, view_count: :desc, id: :asc).offset(offset).limit(limit).to_a
        end
        @posts.delete_if do |p|
            p.id == @post.id or current_user.reported_posts.include?(p) or p.user.blocked_users.include?(current_user) or current_user.blocked_users.include?(p.user)
        end
        if @posts.any?
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end