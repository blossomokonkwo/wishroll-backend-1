class TypingIndicatorNotificationJob < ApplicationJob
    queue_as :notifications
    def perform(user_id, chat_room_id)
        typer = User.find user_id
        chat_room = ChatRoom.find(chat_room_id)
        chat_room_users = ChatRoomUser.where(chat_room_id: chat_room_id).includes(:user)
        if chat_room_users.any?
            app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
            chat_room_users.includes([user: :current_device]).each do |chat_room_user|
                unless chat_room_user.muted
                    user = chat_room_user.user
                    unless user.id == typer.id
                        device = user.current_device
                        if device
                            notification = Rpush::Apns::Notification.new
                            notification.app = app
                            notification.device_token = device.device_token
                            if chat_room.name
                                notification.alert = {body: "#{chat_room.name}\n#{typer.name || typer.username} is typing..."}
                            else
                                notification.alert = {body: "#{typer.name || typer.username} is typing..."}
                            end
                            notification.data = {typing: {username: typer.username, verified: typer.verified, avatar: typer.avatar_url, name: typer.name, typing: true}, chat_room: {id: chat_room.id, name: chat_room.name, num_users: chat_room.num_users, created_at: chat_room.created_at, updated_at: chat_room.updated_at, chat_room_users: []}}
                            notification.save!
                        end
                    end
                end
            end
        end
    end
end