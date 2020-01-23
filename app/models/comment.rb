class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :replies, class_name: "Comment", foreign_key: :original_comment_id, dependent: :destroy
  belongs_to :original_comment, class_name: "Comment", optional: true
  has_many :likes, as: :likeable
end
