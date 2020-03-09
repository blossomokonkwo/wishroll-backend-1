class ChatRoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room, class_name: "ChatRoom", foreign_key: :chat_room_id, counter_cache: :num_users
end
