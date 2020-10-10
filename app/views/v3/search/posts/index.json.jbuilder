json.array! @posts.each do |post|
    user = User.fetch(post.user_id)
    json.id post.id
    json.viewed post.viewed?(@current_user)
    json.view_count post.view_count
    json.bookmarked post.bookmarked?(@current_user)
    json.bookmark_count post.bookmark_count
    json.liked post.liked?(@current_user)
    json.like_count post.likes_count
    json.share_count post.share_count
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
    json.creator do
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user) if user != @current_user
    end
end