cache @chat_room do 
    json.id @chat_room.id
    json.name @chat_room.name
    json.created_at @chat_room.created_at
    json.updated_at @chat_room.updated_at
    json.num_users @chat_room.num_users
    json.recent_message do
        message = @chat_room.recent_message
        json.id message.id
        json.body message.body
        json.kind message.kind
        json.uuid message.uuid
        json.sender_id message.user.id
        json.chat_room_id @chat_room.id
        json.media_url message.media_url
        json.thumbnail_url message.thumbnail_url
        json.created_at message.created_at
        json.updated_at message.updated_at
        messenger = message.user
        json.messenger do
            json.id messenger.id
            json.username messenger.username
            json.avatar messenger.avatar_url
            json.verified messenger.verified
        end 
    end if @chat_room.recent_message
    json.chat_room_users @chat_room.users.each do |user|
        json.id user.id
        json.username user.username
        json.avatar user.avatar_url
        json.name user.name
        json.verified user.verified
    end
end