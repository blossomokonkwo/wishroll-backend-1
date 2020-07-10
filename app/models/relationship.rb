class Relationship < ApplicationRecord
  belongs_to :followed_user, class_name: "User", foreign_key: :followed_id, counter_cache: :followers_count
  belongs_to :follower_user, class_name: "User", foreign_key: :follower_id, counter_cache: :following_count

  after_create do
    unless Activity.find_by(content_id: id, active_user_id: follower_id, user_id: followed_id, activity_type: self.class.name)
      Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "#{follower_user.username} began following you")
    end
  end
end
