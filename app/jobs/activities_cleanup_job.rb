class ActivitiesCleanupJob < ApplicationJob
  queue_as :activities_clean_up

  def perform(activity)
    activity.destroy
  end
end
