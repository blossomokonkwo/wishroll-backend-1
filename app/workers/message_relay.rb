class MessageRelayWorker
    include Sidekiq::Worker
    sidekiq_options queue: "messages"
    def perform(message_id)
        message = Message.find(message_id)
        ChatRoomsChannel.broadcast_to(message.chat_room, message: message.to_json, sender: message.user.to_json)
    end
end