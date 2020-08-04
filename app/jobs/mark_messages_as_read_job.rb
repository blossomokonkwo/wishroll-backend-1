class MarkMessagesAsReadJob < ApplicationJob
    def perform(chat_room_id, user_id)
        user = User.fetch(user_id)
        chat_room = ChatRoom.find(chat_room_id)
        chat_room.messages.find_each do |message|
            message.mark_as_read! for: user if !message.read?(user)
        end
        chat_room.touch
    end
    
end