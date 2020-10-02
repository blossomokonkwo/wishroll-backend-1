json.id @trending_tag.id
json.text @trending_tag.text
json.posts @posts.each do |post|
    json.id post.id
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
    json.viewed post.viewed?(@current_user)
    json.bookmarked post.bookmarked?(@current_user)
    user = User.fetch(post.user_id)
    json.creator do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
    end
end
