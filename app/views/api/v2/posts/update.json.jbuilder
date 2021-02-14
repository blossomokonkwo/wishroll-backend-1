json.id @post.id
json.created_at @post.created_at
json.updated_at @post.updated_at
json.caption @post.caption
json.view_count @post.view_count
json.viewed @post.viewed?(@current_user) if @current_user
json.comment_count @post.comments_count
json.like_count @post.likes_count
json.liked @post.liked?(@current_user) if @current_user
json.bookmark_count @post.bookmark_count 
json.bookmarked @post.bookmarked?(@current_user) if @current_user
json.media_url @post.media_url
json.thumbnail_url @post.thumbnail_url
json.metadata do
    json.width @post.width.to_f
    json.height @post.height.to_f
    json.duration @post.duration.to_f
end
user = User.fetch(@post.user_id)
json.user do
    json.id user.id
    json.username user.username
    json.name user.name
    json.avatar user.avatar_url
    json.following @current_user.following?(user) if @current_user and @current_user != user
end