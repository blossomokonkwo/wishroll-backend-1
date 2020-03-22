class Activity < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :active_user, -> {select([:username, :is_verified, :profile_picture_url])}, class_name: "User", foreign_key: :active_user_id
  #the activity model only has an index action in its controller. 
  #This class is instantiated everytime a comment or post is liked, 
  #a new follow relationship is created or destroyed, a users post appears on the trending page, 
  #a comment is replied to, and when a reaction post is made to an original post
  after_create do
    #we want to delete instances of the activity class after 3 days.
    ActivityCleanUpWorker.perform_in(3.days, self.id)
  end
end
