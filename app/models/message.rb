class Message < ApplicationRecord
    has_one_attached :media_item
    acts_as_readable on: :created_at
    has_one_attached :thumbnail_item
    belongs_to :chat_room, class_name: "ChatRoom", foreign_key: :chat_room_id, touch: true
    belongs_to :user, -> {select([:username, :verified, :avatar_url, :id, :name])}, class_name: "User", foreign_key: :sender_id
    validates :chat_room, presence: true
    validates :kind, presence: true, inclusion: {in: ["text", "emoji", "photo", "video", "audio"]}

    #Returns all of a users unread messages consisting of every chat room that the user is in
    def self.num_unread_messages(user)
        Message.unread_by(user).where(chat_room: user.chat_rooms).count
    end

    #Returns whether or not a message has been read by other users in the chat room other than the user who created the message
    def has_been_read?
        User.where.not(id: user.id).have_read(self).any?
    end

    #Returns whether or not the user has read the specific message
    def read?(user)
        Rails.cache.fetch("Message has been read by #{user.id}") do
            user.have_read?(self)
        end
    end


    
    

end
