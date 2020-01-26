class ActivitiesCleanupJob < ApplicationJob
  queue_as :default

  def perform(activity)
    activity.destroy
  end
end
