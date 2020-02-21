json.followers @followers.each do |user|
    json.user do
        json.username user.username
        json.full_name user.full_name
        json.is_verified usr.is_verified
        json.is_following = user.follower_users.include?(@current_user) ? true : false
    end
end
