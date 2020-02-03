json.array! @users.each do |user|
    cache user, expires_in: 1.hour do 
        json.id user.id
        json.email  user.email
        json.usename user.username
        json.first_name user.first_name
        json.last_name user.last_name
        json.birth_date user.birth_date
        json.is_verified user.is_verified
        json.profile_picture user.profile_picture_url
        json.bio user.bio
        json.followers_count user.followers_count
        json.following_count user.following_count
        json.created_at user.created_at
        json.updated_at user.updated_at
    end
end