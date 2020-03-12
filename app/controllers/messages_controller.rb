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
                ChatRoomsChannel.broadcast_to(@chat_room, message: @message)
                render json: nil, status: 201
            else
                render json: {error: "The message couldn't be created"}, status: 400
            end
        else
            render json: {error: "You are unauthorized to chat in a chat room you have not formally joined"}, status: 401 
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
