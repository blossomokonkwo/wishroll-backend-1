class ChatRoom < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :chat_room_users, dependent: :destroy
  has_many :users, through: :chat_room_users
  has_many :messages, -> {order "updated_at DESC"}, dependent: :destroy, foreign_key: :chat_room_id
  #validations
  validates :creator, presence: true

  def recent_message
    Rails.cache.fetch(cache_key_with_version) {self.messages.order(created_at: :desc).first}
  end
  

  def cached_messages
    Rails.cache.fetch("#{cache_key_with_version}/cached_messages") {self.messages}
  end

  #Returns the number of unread messages by the user in the current chat room. This value is cached and auto expires when a new message is created in this chat room instance
  def num_unread_messages(user)
    Rails.cache.fetch("#{cache_key_with_version}/num_unread_messages/#{user.id}") do
      Message.unread_by(user).where(chat_room: self).where.not(user: user).count
    end
  end
  
  #Returns all of the unread messages by the user in the current chat room.
  def unread_messages(user)
    Rails.cache.fetch("#{cache_key_with_version}/unread_messages/#{user.id}") do
      Message.unread_by(user).where(chat_room: self).where.not(user: user).to_a
    end
  end
  
  
  
  
end
