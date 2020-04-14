json.array! @chat_room_users.each do |chat_room_user|
    user = chat_room_user.user
    cache user, expires_in: 5.minutes do
        json.username user.username
        json.is_verified user.is_verified
        json.profile_picture_url user.profile_picture_url
        json.full_name user.full_name
    end
end
