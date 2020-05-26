json.array! @users.each do |user|
    cache user, expires_in: 5.minutes do
        json.username user.username
        json.full_name user.name
        json.is_verified user.verified
        json.profile_picture_url user.avatar_url
    end
end