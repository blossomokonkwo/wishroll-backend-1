json.following @followed_users.each do |user|
    json.user do
        json.username user.username
        json.full_name user.full_name
        json.is_verified user.is_verified
    end
end
