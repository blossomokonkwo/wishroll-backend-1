class V2::Recommendation::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def recommend
        limit = 9
        offset = params[:offset]
        @post = Post.fetch(params[:post_id])
        keywords = String.new
        english_articles = ["the", "a", "when" "some", "they", "back", "because", "if", "in"]
        @post.fetch_tags.pluck(:text).map {|word| word.split(' ').delete_if {|word| english_articles.include?(word)}.map {|t| keywords << "#{t} "}}
        caption_terms = @post.caption.split(' ').delete_if {|word| english_articles.include?(word)}.map {|word| keywords << "#{word} "}
        @posts = Post.fetch_multi(Tag.search(keywords).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}.delete_if {|p| p.id == params[:post_id]}
        if @post.media_url.ends_with?("mov") or @post.media_url.ends_with?("mp4") or @post.media_url.ends_with?("mv4") or @post.media_url.ends_with?("m4v")
            @posts.delete_if do |p|
                !p.media_url.ends_with?("mov") or !p.media_url.ends_with?("mp4") or !p.media_url.ends_with?("mv4") or !p.media_url.ends_with?("m4v")
            end
        end
        if @posts.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
    
end