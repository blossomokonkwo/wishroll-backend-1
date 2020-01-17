class Comment < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :post, dependent: :destroy
  has_many :replies, class_name: "Reply"
end
