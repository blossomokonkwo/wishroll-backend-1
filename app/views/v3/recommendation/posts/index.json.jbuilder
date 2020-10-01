json.array! @posts.each do |post|
    user = User.fetch(post.user_id)
    json.id post.id
    json.viewed post.viewed?(@current_user)         
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
    json.creator do
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
    end
end