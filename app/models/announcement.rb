class Announcement < ApplicationRecord
    has_one_attached :media_item
    has_one_attached :thumbnail_image
end
