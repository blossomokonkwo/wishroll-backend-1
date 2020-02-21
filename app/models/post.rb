class Post < ApplicationRecord
    has_many :tags, class_name: "Tag", dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :reactions, class_name: "Post", foreign_key: :original_post_id
    belongs_to :original_post, class_name: "Post", optional: true
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    has_many :likes, as: :likeable, dependent: :destroy
    has_one_attached(:post_image)

    private 
    def destroy_post_activities
        activities = Activity.where(content_id: self.id, activity_type: "Post")
        activities.each do |activity|
        activity.destroy
    end if activities.present?
    end
end
