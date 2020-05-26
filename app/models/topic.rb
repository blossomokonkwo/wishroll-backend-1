class Topic < ApplicationRecord
    has_many :chat_rooms, class_name: "ChatRoom",  foreign_key: :topic_id, dependent: :destroy
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    has_one_attached :topic_image
    has_one :location, as: :locatable, dependent: :destroy
    validates :title, presence: true, uniqueness: true, on: [:create, :update]
end
