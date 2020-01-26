class Relationship < ApplicationRecord
  belongs_to :followed_user, class_name: "User", foreign_key: :followed_id, counter_cache: :followers_count
  belongs_to :follower_user, class_name: "User", foreign_key: :follower_id, counter_cache: :following_count
end
