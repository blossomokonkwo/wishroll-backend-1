json.users @users.each do |user|
        json.username user.username
        json.full_name user.full_name
        json.is_verified user.is_verified
        json.profile_picture_url url_for(user.profile_picture) if user.profile_picture.attached?
end
json.posts @posts.each do |post|
    json.id post.id
    json.user_id post.user_id
    json.view_count post.view_count
    json.likes_count post.likes_count
    if post.likes.find_by(user_id: @id)
        json.liked true
    else
        json.liked false
    end
    json.comments_count post.comments_count
    json.original_post_id post.original_post_id
    json.caption post.caption
    json.created_at post.created_at
    json.media_url post.posts_media_url
end