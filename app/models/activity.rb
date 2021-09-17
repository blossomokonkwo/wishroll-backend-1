class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :active_user, -> {select([:username, :name, :verified, :avatar_url, :id])}, class_name: "User", foreign_key: :active_user_id
  
  
  after_create do
    #we want to delete instances of the activity class after 3 days.
    ActivitiesCleanupJob.set(wait: 3.weeks).perform_later(self.id)
    ActivityNotificationJob.perform_now(self.id) if activity_type != "Like" and activity_type != "Share"
  end
end
