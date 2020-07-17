json.array! @posts.each do |post|
    user = post.fetch_user
    cache post, expires_in: 5.minutes do
        json.id post.id
        json.created_at post.created_at
        json.updated_at post.updated_at
        json.view_count post.view_count
        json.comment_count post.comments_count
        json.like_count post.likes_count
        json.share_count post.share_count
        json.liked post.liked?(@current_user)
        json.viewed post.viewed?(@current_user)
        json.bookmarked post.bookmarked?(@current_user)
        json.bookmark_count post.bookmark_count
        json.caption post.caption           
        json.media_url post.media_url
        json.thumbnail_url post.thumbnail_url
        json.creator do 
            json.id user.id
            json.username user.username
            json.verified user.verified
            json.avatar user.avatar_url
        end
    end
end