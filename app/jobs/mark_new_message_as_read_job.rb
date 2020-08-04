class MarkNewMessageAsReadJob < ApplicationJob
    def perform(message_id, chat_room_id)
        chat_room = ChatRoom.find(chat_room_id)
        message = Message.find(message_id)
        chat_room.chat_room_users.where(appearance: true).includes(:user).find_each do |chat_room_user|
            message.mark_as_read! for: chat_room_user.user
        end
        chat_room.touch
    end
    
end