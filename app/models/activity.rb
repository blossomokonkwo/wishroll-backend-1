class Activity < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :active_user, class_name: "User"
  #the activity model only has an index action in its controller. 
  #This class is instantiated everytime a comment or post is liked, 
  #a new follow relationship is created or destroyed, a users post appears on the trending page, 
  #a comment is replied to, and when a reaction post is made to an original post
  after_create do
    #we want to delete instances of the activity class after 3 days.
    ActivitiesCleanupJob.set(wait_until: DateTime.current + 3.days).perform_later(self)
  end
end
