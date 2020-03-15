class MessagesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @chat_room = ChatRoom.find(params[:chat_room_id])
        if @chat_room.users.include?(current_user)
            @message = @chat_room.messages.create(body: params[:body], sender_id: current_user.id, kind: params[:kind])
            if params[:media_item]
                @message.media_item.attach(params[:media_item])
                @message.media_url = url_for(@message.media_item)
            end
            if @message.save
                #MessageRelayJob.perform_later(@message)
                ChatRoomsChannel.broadcast_to(@message.chat_room, message: @message.to_json, sender: @message.user.to_json)
                #a background job should handle the pushing of notifications to users whom are members of the chat room
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
