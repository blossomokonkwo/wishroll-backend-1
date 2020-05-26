class Comment < ApplicationRecord
  belongs_to :user, -> {select([:username, :verified, :avatar_url, :id])}, foreign_key: :user_id
  belongs_to :post, counter_cache: :comments_count, foreign_key: :post_id, optional: true
  belongs_to :roll, counter_cache: :comments_count, foreign_key: :roll_id, optional: true
  has_many :replies, class_name: "Comment", foreign_key: :original_comment_id, dependent: :destroy
  belongs_to :original_comment, class_name: "Comment", optional: true, counter_cache: :replies_count
  has_many :likes, as: :likeable
  
  before_destroy :destroy_comments_activities
  def liked?(user_id)
    likes.where(user_id: user_id).exists?
  end

  private 
  def destroy_comments_activities
    activities = Activity.where(content_id: self.id, activity_type: "Comment")
    activities.each do |activity|
      activity.destroy
    end if activities.any?
  end
end
