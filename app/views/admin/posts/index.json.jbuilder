json.array! @posts.each do |post|
    cache post, expires_in: 10.minutes do
        json.(post, :id, :created_at, :updated_at, :caption, :original_post_id, :posts_media_url, :view_count, :likes_count, :comments_count)   
    end
end