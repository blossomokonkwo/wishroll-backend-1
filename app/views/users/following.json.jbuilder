json.following @followed_users.each do |user|
    json.user do
        json.username user.username
        json.full_name user.name
        json.is_verified user.verified
        json.profile_picture_url user.avatar_url
        json.is_following @current_user.followed_users.include?(user) ? true : false
    end
end
