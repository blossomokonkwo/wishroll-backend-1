class UserBlockedPost < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :post
  validates :reason, presence: true
end
