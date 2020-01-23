class Post < ApplicationRecord
    has_many :tags, class_name: "Tag", dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :reactions, class_name: "Post", foreign_key: :original_post_id
    belongs_to :original_post, class_name: "Post", optional: true
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    has_many :likes, as: :likeable
    has_one_attached(:post_image)
end
