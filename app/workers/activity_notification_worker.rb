class ActivityNotificationWorker 
    include Sidekiq::Worker
    sidekiq_options queue: "notifications", retry: false
    def perform(activity_id)
        activity = Activity.find(activity_id)
        if activity
            user = User.find(activity.user_id)
            n = Rpush::Apns::Notification.new
            n.app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
            n.device_token = user.current_device.device_token
            if activity.post_url
            n.alert = "#{activity.activity_phrase}\n#{activity.post_url}"
            else
                n.alert = "#{activity.activity_phrase}"
            end
            n.sound = 'sosumi.aiff'
            n.data = {}
            n.save!
            Rpush.push
        end        
    end
end