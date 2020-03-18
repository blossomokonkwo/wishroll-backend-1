json.array! @messages.includes([:chat_room, :user]).each do |message|
    cache message, expires_in: 1.hour do
        json.message do
            json.id message.id
            json.body message.body
            json.kind message.kind
            json.uuid message.uuid
            json.sender_id message.user.id
            json.chat_room_id message.chat_room.id
            json.media_url message.media_url
            json.created_at message.created_at
            json.updated_at message.updated_at
        end
    end
    messenger = message.user
    cache messenger, expires_in: 1.hour do
        json.user do
            json.id messenger.id
            json.username messenger.username
            json.profile_picture_url messenger.profile_picture_url
            json.is_verified messenger.is_verified
        end 
    end
end