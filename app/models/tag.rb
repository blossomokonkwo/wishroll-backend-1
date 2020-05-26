class Tag < ApplicationRecord
    belongs_to :post, class_name: "Post", foreign_key: :post_id
    belongs_to :roll, class_name: "Roll", foreign_key: :roll_id
    has_one :location, as: :locateable, dependent: :destroy
    validates :text, presence: true
end
