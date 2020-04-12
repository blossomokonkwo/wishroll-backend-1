class ActivitiesCleanupJob < ApplicationJob
  queue_as :clean_up
     #destroys old activities from the data base
    #finds the activity record based on the id and destroys it.
    def perform(activity_id)
      activity = Activity.find(activity_id)
      activity.destroy
    end
end
