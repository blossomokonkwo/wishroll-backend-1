json.array! @chat_room_users.each do |chat_room_user|
    user = chat_room_user.user
    cache user, expires_in: 20.minutes do
            json.id user.id
            json.username user.username
            json.full_name user.full_name
            json.profile_picture_url user.profile_picture_url
            json.is_following @current_user.followed_users.include?(user)
            json.is_verified user.is_verified
            json.appearance  chat_room_user.appearance
            json.updated_at  chat_room_user.updated_at
    end   
end 
