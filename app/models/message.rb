class Message < ApplicationRecord
    has_one_attached :media_item
    belongs_to :chat_room, class_name: "ChatRoom", foreign_key: "chat_room_id"
    validates :kind, presence: true, inclusion: {in: ["text", "emoji", "photo", "video", "audio"]}
    belongs_to :user, class_name: "User", foreign_key: :sender_id
end
