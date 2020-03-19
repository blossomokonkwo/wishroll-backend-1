class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast_to(message.chat_room, message: message.to_json, sender: message.user.to_json)
  end
end
