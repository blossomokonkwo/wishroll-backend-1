class Message < ApplicationRecord
    has_one_attached :media_item
    validates :kind, presence: true, inclusion: {in: ["text", "emoji", "photo", "video", "audio"]}
end
