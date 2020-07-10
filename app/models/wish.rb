class Wish < ApplicationRecord
  validates :description, length: {minimum:1, maximum:100}
  belongs_to :user
  belongs_to :wishlist, counter_cache: :wishes_count
  has_one_attached :wish_picture #each wish contains a photo showing donators the wish
end