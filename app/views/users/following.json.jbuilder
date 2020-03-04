json.following @followed_users.each do |user|
    json.user do
        json.username user.username
        json.full_name user.full_name
        json.is_verified user.is_verified
        json.profile_picture_url user.profile_picture_url
        json.is_following user.follower_users.include?(@current_user) ? true : false
    end
end
