json.array! @messages.includes([:user]).each do |message|
    cache message, expires_in: 5.minutes do
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
            json.has_been_read message.has_been_read?
        end
    messenger = message.user
    cache messenger, expires_in: 1.hour do
        json.messenger do
            json.id messenger.id
            json.username messenger.username
            json.avatar messenger.avatar_url
            json.verified messenger.verified
        end 
    end
end