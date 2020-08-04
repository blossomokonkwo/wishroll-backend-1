class V2::MessagesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        @chat_room = ChatRoom.find(params[:chat_room_id])
        if @chat_room.users.include?(current_user)
            @message = @chat_room.messages.create(body: params[:body], sender_id: current_user.id, kind: params[:kind])
            @message.media_item.attach(params[:media_item]) if params[:media_item]
            @message.thumbnail_item.attach(params[:thumbnail_item]) if params[:thumbnail_item]
            @message.media_url = polymorphic_url(@message.media_item) if @message.media_item.attached?
            @message.thumbnail_url = polymorphic_url(@message.thumbnail_item) if @message.thumbnail_item.attached?
            if @message.save  
                id = @message.id
                MarkNewMessageAsReadJob.perform_now(id, params[:chat_room_id])
                MessageRelayJob.perform_now(id)
                MessageNotificationJob.perform_now(id)
                render json: nil, status: :created
            else
                render json: {error: "The message couldn't be created"}, status: 400
            end
        else
            render json: {error: "You are unauthorized to chat in a chat room you have not formally joined"}, status: :unauthorized 
        end
    end


    def index
        @chat_room = ChatRoom.find(params[:chat_room_id])
        if @chat_room
            limit = 15
            offset = params[:offset]
            @messages = @chat_room.messages.offset(offset).limit(limit)
            if @messages.any?
                render :index, status: :ok
            else
                render json: {error: "This chat room has no messages"}, status: :not_found
            end
        else
            render json: {error: "This chat room does not exist"}, status: :not_found
        end
    end

    def update
        @message = Message.find(params[:id])
        if @message.update(params[:body])
            render json: nil, status: :ok
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