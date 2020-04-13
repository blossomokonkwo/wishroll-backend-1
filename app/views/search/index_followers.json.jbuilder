json.array! @users.each do |user|
    json.username user.username
    json.full_name user.full_name
    json.is_verified user.is_verified
    json.profile_picture_url user.profile_picture_url
end