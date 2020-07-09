json.array! @albums.each do |album|
    json.id album.id
    json.name album.name
    json.thumbnail_url album.thumbnail_url
    json.post_count album.post_count
    json.created_at album.created_at
    json.updated_at album.updated_at
    json.post_count album.post_count
    json.private album.private
    json.creator do 
        user = album.user
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
        json.following @current_user.following?(user) if user != @current_user
    end
end
