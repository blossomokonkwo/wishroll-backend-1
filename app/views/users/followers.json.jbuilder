json.followers @followers.each do |user|
    json.user do
        json.username user.username
        json.full_name user.name
        json.is_verified user.verified
        json.profile_picture_url user.avatar_url
        json.is_following user.follower_users.include?(@current_user) ? true : false
    end
end
