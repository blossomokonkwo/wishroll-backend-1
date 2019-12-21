class Post < ApplicationRecord
    has_many :Tags, class_name: "Tag", dependent: :destroy
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    has_one_attached(:post_image)
end
