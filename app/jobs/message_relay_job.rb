class MessageRelayJob < ApplicationJob
  queue_as :messages

  def perform(message)
    ActionCable.server.broadcast message.chat_room, message: message
  end
end
