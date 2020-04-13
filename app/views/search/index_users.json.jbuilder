json.array! @users.each do |user|
    cache user, expires_in: 5.minutes do
        json.username user.username
        json.full_name user.full_name
        json.is_verified user.is_verified
        json.profile_picture_url user.profile_picture_url
    end
end