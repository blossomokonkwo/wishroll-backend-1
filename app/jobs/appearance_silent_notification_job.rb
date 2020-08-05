class AppearanceSilentNotificationJob < ApplicationJob
    queue_as :notifications
    def perform(user_id)
        user = User.fetch(user_id)
        n = Rpush::Apns::Notification.new
        n.app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
        if n.device_token = user.current_device.device_token
            n.content_available = true
            n.badge = Message.num_unread_messages(user)
            n.save!
        end
    end
    
end