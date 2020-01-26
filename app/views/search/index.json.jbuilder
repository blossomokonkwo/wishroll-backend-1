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
    json.caption post.caption
    json.created_at post.created_at
    json.media_url post.posts_media_url
end