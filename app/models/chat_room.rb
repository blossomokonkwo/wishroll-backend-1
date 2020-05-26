class ChatRoom < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :chat_room_users, dependent: :destroy
  has_many :users, through: :chat_room_users
  has_many :messages, -> {order "updated_at DESC"}, dependent: :destroy, foreign_key: :chat_room_id
  has_one :recent_message, -> {(order "updated_at DESC").limit(1)}, class_name: "Message", foreign_key: :chat_room_id
  #validations
  validates :creator, presence: true

  def cached_messages
    Rails.cache.fetch("#{cache_key_with_version}/cached_messages") {self.messages}
  end
  
  
end
