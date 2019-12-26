class SearchController < ApplicationController
    before_action :authorize_by_access_header!
    def search 
        @posts = Array.new
        Tag.where(text: search_params[:text]).find_each do |tag|
            #the posts array should only include posts from unique tag objects 
                post = Hash.new
                tag.post.view_count += 1
                post[:id] = tag.post.id
                post[:caption] = tag.post.caption
                post[:created_at] = tag.post.created_at
                post[:user_id] = tag.post.user_id
                post[:view_count] = tag.post.view_count
                post[:image_url] = url_for(tag.post.post_image) if tag.post.post_image.attached?
                @posts << post
        end
        if @posts.empty?
            render status: 404
        else
            render json: {posts: @posts}, status: :ok
        end

    end


    private 
    def search_params
        params.permit :text
    end
end
