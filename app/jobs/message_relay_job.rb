class MessageRelayJob < ApplicationJob
  queue_as :messages
  sidekiq_options retry: 5
  def perform(message_id)
    message = Message.find(message_id)
    messenger = message.user
    ChatRoomsChannel.broadcast_to(message.chat_room, {id: message.id, uuid: message.uuid, body: message.body, kind: message.kind, media_url: message.media_url, thumbnail_url: message.thumbnail_url, created_at: message.created_at, updated_at: message.updated_at, chat_room_id: message.chat_room_id, messenger: {id: messenger.id, username: messenger.username, avatar: messenger.avatar_url, verified: messenger.verified}}.to_json)
  end
end
