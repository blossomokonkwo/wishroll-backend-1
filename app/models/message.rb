class Message < ApplicationRecord
    has_one_attached :media_item
    has_one_attached :thumbnail_item
    belongs_to :chat_room, class_name: "ChatRoom", foreign_key: :chat_room_id, touch: true
    belongs_to :user, -> {select([:username, :verified, :avatar_url, :id, :name])}, class_name: "User", foreign_key: :sender_id
    validates :chat_room, presence: true
    validates :kind, presence: true, inclusion: {in: ["text", "emoji", "photo", "video", "audio"]}
end
