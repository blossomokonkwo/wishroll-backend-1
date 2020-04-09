class MessageNotificationWorker
    include Sidekiq::Worker
    sidekiq_options queue: "notifications", retry: false

    #The message notification worker encapsulates all of the functionality that is required to push a notification to
    #a user prompting them to check out an unread message. The logic that is needed to perform such an operation is as follows.
    #First we need to distinguish between an unread and read message. 
    #1. A message or a collection of messages are deemed as read when a user appears in the chat room of that message or messages.
    #2. The sum of a users unread messages can be calculated by adding the all the messages sent in a chat room that the user belongs to that he/she has not read - not entered the chat room since-.
    #ex) If user A enters a chat room, all the unread messages in that chat room are then marked as read. If the same user leaves the same chat room - by clicking out of the chat room or swiping out - any new messages in that chat room will be marked as unread.
    #3. Users should only recieve remote push notifications when they are outside of the app. Users should recieve in app notifications when they're in app but not in the chat room from whenst the notification is coming from.
    #4. Users should not recieve any notification when they're currently in the chat room that the message was sent from.
    #5. The Message controller class handles all of the logic that is required to send the remote push notifications to the need users - the users in the chat room except for the message sender.
    #6. The notifications should display the sender of the message, the content of the message - if a media item the url - and a sound that allows the app to uniquely recognize the app.

        #the message_id is used to look find the message object.
        #the chat room user ids is used to find the chat room user objects that are present or absent from the chat room
        #the sender_id is used to find the user that sent the
    def perform(message_id)
        @message = Message.find(message_id)
        chat_room_users = @message.chat_room.users#ChatRoomUser.where(chat_room_id: @message.chat_room.id).includes(:user)
        sender = @message.user #the sender is the person who sent the message. They should not recieve any notifications
        #first check if there are any chat room users left in the chat room
        if chat_room_users.any?
            #loop through all the chat room users
            chat_room_users.each do |chat_room_user|
                #if the chat room user is not currently present in the chat room, then they are sendable 
                #if !chat_room_user.appearance
                    #user = chat_room_user.user
                    device = chat_room_user.devices.last #find the user of the chat room user
                    #if (user.id != sender.id) and device.present?
                        #if the user has a device in the data base, then append the devices token
                    if device 
                        notification = Rpush::Apns::Notification.new
                        notification.app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
                        notification.device_token = device.device_token
                        if @message.media_url
                            notification.alert = "[#{sender.username}]: #{@message.media_url}"
                        else
                            notification.alert = "[#{sender.username}]: #{@message.body}"
                        end
                        notification.sound = 'sosumi.aiff'
                        notification.data = {}
                        notification.save!
                        Rpush.push
                    end
            end            
        end
    end
end