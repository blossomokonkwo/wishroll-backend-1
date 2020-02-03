json.array! @posts.each do |post|
    cache post, expires_in: 5.minutes do
        json.id post.id
        json.user_id post.user_id
        json.original_post_id post.original_post_id
        json.created_at post.created_at
        json.view_count post.view_count
        json.comments_count post.comments_count
        json.likes_count post.likes_count
        if post.likes.find_by(user_id: @id)
            json.liked true
        else
            json.liked false
        end
        json.caption post.caption           
        json.media_url post.posts_media_url
    end
end
