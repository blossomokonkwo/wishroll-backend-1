class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count
  belongs_to :user, class_name: "User"

  before_destroy :destroy_likes_activities

  def destroy_likes_activities
    activities = Activity.where(content_id: self.id, activity_type: self.likeable_type)
    activities.each do |activity|
      activity.destroy
    end if activities.present?
  end
end
