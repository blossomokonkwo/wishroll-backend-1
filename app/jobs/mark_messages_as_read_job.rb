class MarkMessagesAsReadJob < ApplicationJob
    def perform(chat_room_id, user_id)
        user = User.fetch(user_id)
        chat_room = ChatRoom.find(chat_room_id)
        Message.unread_by(user).where(chat_room: chat_room).find_each do |message|
            message.mark_as_read! for: user
        end
        chat_room.touch
    end
    
end