class MessageNotificationJob < ApplicationJob
    queue_as :notifications
    sidekiq_options retry: 1
    #The message notification worker encapsulates all of the functionality that is required to push a notification to
    #a user prompting them to check out an unread message. The logic that is needed to perform such an operation is as follows.
    #First we need to distinguish between an unread and read message. 
    #1. A message or a collection of messages are deemed as read when a user appears in the chat room of that message or messages.
    #2. The sum of a users unread messages can be calculated by adding the all the messages sent in a chat room that the user belongs to that he/she has not read - not entered the chat room since-.
    #ex) If user A enters a chat room, all the unread messages in that chat room are then marked as read. If the same user leaves the same chat room - by clicking out of the chat room or swiping out - any new messages in that chat room will be marked as unread.
    #3. Users should only recieve remote push notifications when they are outside of the app. Users should recieve in app notifications when they're in app but not in the chat room from whenst the notification is coming from.
    #4. Users should not recieve any notification when they're currently in the chat room that the message was sent from.
    #5. The Message controller class handles all of the logic that is required to send the remote push notifications to the need users - the users in the chat room except for the message messenger.
    #6. The notifications should display the messenger of the message, the content of the message - if a media item the url - and a sound that allows the app to uniquely recognize the app.
    def perform(message_id)
        @message = Message.find(message_id)
        chat_room = @message.chat_room
        chat_room_users = ChatRoomUser.where(chat_room_id: chat_room.id).includes(:user)
        messenger = @message.user #the messenger is the person who sent the message. They should not recieve any notifications
        #first check if there are any chat room users left in the chat room
        if chat_room_users.any?
            #loop through all the chat room users
            app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
            chat_room_users.includes([user: :current_device]).each do |chat_room_user|
                unless chat_room_user.muted
                    user = chat_room_user.user
                    unless user.id == messenger.id
                        device = user.current_device  #find the user of the chat room user
                        if device 
                            notification = Rpush::Apns::Notification.new
                            notification.app = app
                            notification.device_token = device.device_token
                            if chat_room.name
                                if @message.media_url
                                    if @message.media_url.end_with?("mp4") or @message.media_url.end_with?("mov") or @message.media_url.end_with?("m4v")
                                        notification.alert = {title: "#{chat_room.name}", subtitle: "#{messenger.name || messenger.username}", body: "sent a reaction video"}
                                    elsif @message.media_url.end_with?("gif")
                                        notification.alert = {title: "#{chat_room.name}", subtitle: "#{messenger.name || messenger.username}", body: "sent a reaction gif"}
                                    else
                                        notification.alert = {title: "#{chat_room.name}", subtitle: "#{messenger.name || messenger.username}", body: "sent a reaction photo"}
                                    end
                                else
                                    notification.alert = {title: "#{chat_room.name}", subtitle: "#{messenger.name || messenger.username}", body: "#{@message.body}"}
                                end
                            else
                                if @message.media_url
                                    if @message.media_url.end_with?("mp4") or @message.media_url.end_with?("mov") or @message.media_url.end_with?("m4v")
                                        notification.alert = {title: "#{messenger.name || messenger.username}", body: "sent a reaction video"}
                                    elsif @message.media_url.end_with?("gif")
                                        notification.alert = {title: "#{messenger.name || messenger.username}", body: "sent a reaction gif"}
                                    else
                                        notification.alert = {title: "#{messenger.name || messenger.username}", body: "sent a reaction photo"}
                                    end
                                else
                                    notification.alert = {title: "#{messenger.name || messenger.username}", body: "#{@message.body}"}
                                end
                            end
                            notification.sound = 'message_notification_sound.caf'
                            notification.category = "MESSAGE"
                            notification.badge = Message.num_unread_messages(user)
                            notification.mutable_content = true
                            notification.data = {message: { id: @message.id, uuid: @message.uuid, kind: @message.kind, body: @message.body, media_url: @message.media_url, thumbnail_url: @message.thumbnail_url, created_at: @message.created_at, updated_at: @message.updated_at, chat_room_id: @message.chat_room_id, messenger: {id: messenger.id, username: messenger.username, verified: messenger.verified, avatar: messenger.avatar_url}}, chat_room: {id: chat_room.id, name: chat_room.name, created_at: chat_room.created_at, updated_at: chat_room.updated_at, num_users: chat_room.num_users, num_unread_messages: chat_room.num_unread_messages(user), chat_room_users: []}}
                            notification.save!
                        end
                    end
                end
            end            
        end
    end
end