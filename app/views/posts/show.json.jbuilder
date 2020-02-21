json.user do 
    json.username @user.username
    json.is_verified @user.is_verified
    json.profile_picture_url url_for(@user.profile_picture) if @user.profile_picture.attached?
end
json.post do 
    json.id @post.id
    json.view_count @post.view_count
    json.comments_count @post.comments_count
    json.likes_count @post.likes_count
    if @post.likes.find_by(user_id: @id)
        json.liked true
    else
        json.liked false
    end
    json.caption @post.caption
    json.created_at @post.created_at
    json.media_url @post.posts_media_url
    json.original_post_id @post.original_post_id
end
json.tags @post.tags, :id, :text     