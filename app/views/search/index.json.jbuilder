json.users @users.each do |user|
        json.username user.username
        json.full_name user.name
        json.is_verified user.verified
        json.profile_picture_url user.avatar_url
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
    json.original_post_id nil
    json.caption post.caption
    json.created_at post.created_at
    json.media_url post.media_url
end