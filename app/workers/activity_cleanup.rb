class ActivityCleanUpWorker
    include Sidekiq::Worker
    sidekiq_options queue: :clean_up

    #destroys old activities from the data base
    #finds the activity record based on the id and destroys it.
    def perform(activity_id)
        activity = Activity.find(activity_id)
        activity.destroy
    end
end