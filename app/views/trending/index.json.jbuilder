json.array! @posts.each do |post|
    cache post, expires_in: 5.minutes do
        json.id post.id
        json.user_id post.user_id
        json.original_post_id nil
        json.created_at post.created_at
        json.view_count post.view_count
        json.comments_count post.comments_count
        json.likes_count post.likes_count
        json.liked post.liked?(@id)
        json.caption post.caption           
        json.media_url post.media_url
    end
end
