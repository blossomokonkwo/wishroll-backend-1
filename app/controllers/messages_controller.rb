class MessagesController < ApplicationController
    require 'profanity_filter'
    before_action :authorize_by_access_header!
    def create
        @chat_room = ChatRoom.find(params[:chat_room_id])
        if @chat_room.users.include?(current_user)
            @message = @chat_room.messages.create(body: params[:body], sender_id: current_user.id, kind: params[:kind])
            if params[:media_item]
                @message.media_item.attach(params[:media_item])
                @message.media_url = polymorphic_url(@message.media_item)
            end
            #if the chat room is under a hot topic - which all of our users can view - then the messages passed in these chat rooms should be filtered in order to 
            #protect our users old and young 
            if @chat_room.topic and @chat_room.topic.hot_topic
                profanity_filter = ProfanityFilter.new #instantiate a new ProfanityFilter object and filter the message body of the message
                @message.body = profanity_filter.filter_message(@message.body) if @message.body
            end
            if @message.save  
                #the message relay worker is responsible for forwarding the message to the channel subscribers. The MessageNotificationWorker is responsible 
                #for deciding which users are inactive - not in the chat room that the message belongs to - and sending these users a notification.
                id = @message.id
                MessageRelayWorker.perform_async(id)
                MessageNotificationWorker.perform_async(id)
                #we pass in the id of the messages, the ids of the chat room users, the id of the current user, and the id of the chat room.
                #the notification worker should handle the filtering of appropriate notification recievers as follows: the current_user - the user who sent the message- 
                #should not recieve the notification. The users who are present in the chat room should also not recieve the notification. Only the users who are not the
                #current sender and are not present in the chat room should recieve the notification.
                render json: nil, status: 201
            else
                render json: {error: "The message couldn't be created"}, status: 400
            end
        else
            render json: {error: "You are unauthorized to chat in a chat room you have not formally joined"}, status: 401 
        end
    end


    def index
        #return all the messages for a given chat room using offset and limit constraints. As the user scrolls upwards in the chat, they should be viewing older messages.
        #for smooth scrolling and performance the limit will be 75 messages
        @chat_room = ChatRoom.find(params[:chat_room_id])
        if @chat_room
            #these will be passed in as query params
            limit = 50
            offset = params[:offset]
            @messages = @chat_room.messages.offset(offset).limit(limit)
            if @messages.any?
                render :index, status: 200
            else
                render json: {error: "This chat room has no messages"}, status: 404
            end
        else
            render json: {error: "This chat room does not exist"}, status: 404
        end
    end
     
    def typing
        #called when a user has began typing
    end

    def notTyping
        #called when user has finished typing
    end
    def appearance 
        #called when a user has joined a chat room
    end
    def disappearance
        #called when a user has left a chat room 
    end

    def update
        @message = Message.find(params[:id])
        if @message.update(params[:body])
            render json: nil, status: 200
        else
            render json: {error: "Could not update message"}, status: 400
        end
    end

    def destroy
        @message = Message.find(params[:id])
        if @message.destroy
            render json: nil, status: :ok
        else
            render json: {error: "Could not delete this message"}, status: 400
        end
    end
    
end
