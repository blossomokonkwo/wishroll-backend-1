class Post < ApplicationRecord
    has_many :tags, class_name: "Tag", dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :replies, dependent: :destroy
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    has_one_attached(:post_image)
end
