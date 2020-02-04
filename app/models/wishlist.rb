class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishes, dependent: :destroy
end
