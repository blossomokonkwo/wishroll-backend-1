class MessageRelayJob < ApplicationJob
  queue_as :messages
  sidekiq_options retry: 5
  def perform(message_id)
    message = Message.find(message_id)
    ChatRoomsChannel.broadcast_to(message.chat_room, message: message.to_json, sender: message.user.to_json)
  end
end
