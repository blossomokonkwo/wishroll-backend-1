json.array! @trending_tags.each do |tag|
    json.id tag.id
    json.text tag.text
    json.posts tag.posts(limit: 3, offset: 0).each do |post|
        json.id post.id
        json.media_url post.media_url
        json.thumbnail_url post.thumbnail_url
        json.viewed post.viewed?(@current_user)
        json.bookmarked post.bookmarked?(@current_user)
        user = User.fetch(post.user_id)
        json.creator do
            json.id user.id
            json.username user.username
            json.avatar user.avatar_url
            json.verified user.verified
        end
    end
end