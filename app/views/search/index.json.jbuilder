json.array! @users.each do |user|
    json.user do 
        json.username user.username
        json.first_name user.first_name
        json.last_name user.last_name
        json.is_verified user.is_verified
        json.profile_picture_url user.profile_picture_url
    end
end
json.array! @posts.each do |post|
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