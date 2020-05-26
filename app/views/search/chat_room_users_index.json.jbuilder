json.array! @chat_room_users.each do |chat_room_user|
    user = chat_room_user.user
    cache user, expires_in: 5.minutes do
        json.username user.username
        json.is_verified user.verified
        json.profile_picture_url user.avatar_url
        json.full_name user.name
    end
end
