json.array! @posts.each do |post|
    json.id post.id
    json.created_at post.created_at
    json.updated_at post.updated_at
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
    json.comment_count post.comments_count
    json.viewed post.viewed?(@current_user)
    json.view_count post.view_count
    json.liked post.liked?(@current_user)
    json.like_count post.likes_count
    json.bookmarked post.bookmarked?(@current_user)
    json.bookmark_count post.bookmark_count
    json.share_count post.share_count
    json.caption post.caption           
    json.user do 
        json.id @current_user.id
        json.username @current_user.username
        json.name @current_user.name
        json.verified @current_user.verified
        json.avatar @current_user.avatar_url
    end
end