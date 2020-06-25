json.array! @posts.each do |post|
    user = post.user
    json.id post.id
    json.created_at post.created_at
    json.updated_at post.updated_at
    json.views post.view_count
    json.shares post.share_count
    json.viewed post.viewed?(@current_user.id)
    json.bookmarked post.bookmarked?(@current_user.id)
    json.bookmark_count post.bookmark_count
    json.comments_count post.comments_count
    json.likes post.likes_count
    json.liked post.liked?(@current_user.id)
    json.caption post.caption           
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
    json.creator do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user)
    end
end