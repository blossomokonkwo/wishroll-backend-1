json.chat_room do 
    cache @chat_room, expires_in: 20.minutes do
        json.id @chat_room.id
        json.name @chat_room.name
        json.created_at @chat_room.created_at
        json.
    end
end
json.chat_room_users @chat_room.users.each do |user|
    cache user, expires_in: 20.minutes do
        json.chat_room_user do
            json.id user.id
            json.username user.username
            json.profile_picture_url user.profile_picture_url
            json.is_verified user.is_verified
        end
    end
    
end if @chat_room.users.any?
