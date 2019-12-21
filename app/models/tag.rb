class Tag < ApplicationRecord
    belongs_to :post, class_name: "Post", foreign_key: "post_id"
    validates :text, presence: true
end
