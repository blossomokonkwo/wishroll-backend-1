class Activity < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :active_user, -> {select([:username, :verified, :avatar_url])}, class_name: "User", foreign_key: :active_user_id
  
  
  after_create do
    #we want to delete instances of the activity class after 3 days.
    ActivitiesCleanupJob.set(wait: 1.week).perform_later(self.id)
    ActivityNotificationJob.perform_now(self.id)
  end
end
