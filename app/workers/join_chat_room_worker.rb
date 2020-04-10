class JoinChatRoomWorker
    include Sidekiq::Worker
    sidekiq_options queue: "notifications", retry: false
    def perform(user_id, chat_room_id)
        joined_user = User.find(user_id)
        chat_room_users = ChatRoomUser.where(chat_room_id: chat_room_id).includes(:user)
        if chat_room_users.any?
            chat_room_users.each do |chat_room_user|
                unless chat_room_user.muted
                    user = chat_room_user.user
                    device = user.current_device
                    if device
                        notification = Rpush::Apns::Notification.new
                        notification.app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
                        notification.device_token = device.device_token
                        notification.alert = "#{user.username} has joined the chat..."
                        notification.sound = 'sosumi.aiff'
                        notification.data = {}
                        notification.save!
                        Rpush.push
                    end
                end
            end
        end
    end
end