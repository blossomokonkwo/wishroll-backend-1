class MessageRelayJob < ApplicationJob
  queue_as :messages

  def perform(message)
    ActionCable.server.broadcast "chatrooms:#{message.chatroom.id}", message: message
  end
end
