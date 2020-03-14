json.array! @chat_room_users.each do |user|
    cache user, expires_in: 20.minutes do
            json.id user.id
            json.username user.username
            json.full_name user.full_name
            json.profile_picture_url user.profile_picture_url
            json.is_following @current_user.followed_users.include?(user)
            json.is_verified user.is_verified
    end   
end 
