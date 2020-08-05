class V2::ChatRoomUsersController < ApplicationController
    before_action :authorize_by_access_header!
    def index
        limit = 12
        offset = params[:offset]
        @users = ChatRoom.find(params[:chat_room_id]).users.order("chat_room_users.created_at DESC").offset(offset).limit(limit)
        if @users.any?
            @current_user = current_user
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def destroy
        chat_room_user = ChatRoomUser.find_by(chat_room_id: params[:chat_room_id], user_id: current_user.id)
        if chat_room_user.destroy
            render json: nil, status: :ok
        else
            render json: nil, status: :bad_request
        end
    end

    def update
        @chat_room = ChatRoom.find(params[:chat_room_id])
        params[:user_ids].each do |id|
            user = User.fetch(id)
            @chat_room.users << user if !@chat_room.users.include?(user)
        end
        render json: nil, status: :ok
    end

    def appear
        #called when a user first appears in a chat room. The users appearance data is then broadcasted to all the other chat room members.
        #The broadcasted data can be used to display to users the active users in the chat room
        @chat_room_user = ChatRoomUser.find_by(user_id: current_user.id, chat_room_id: params[:id])
        if @chat_room_user
            begin
                MarkMessagesAsReadJob.perform_now(params[:id], current_user.id)
                @chat_room_user.update!(appearance: true, last_seen: DateTime.current)
                @chat_room = ChatRoom.find(params[:id])
                AppearancesChannel.broadcast_to(@chat_room, {username: current_user.username, appearance: true}.to_json)
                AppearanceSilentNotificationJob.perform_now(current_user.id)
                render json: nil, status: :ok
            rescue => exception
                render json: nil, status: 500
            end
        else
          render json: nil, status: :not_found
        end
    end



    def disappear
        #called when a user exits the chat room page of a chat room. The broad cast helps viewing users to be updated in real time when another user is no longer active in a chat room
        @chat_room_user = ChatRoomUser.find_by(user_id: current_user.id, chat_room_id: params[:id])
        if @chat_room_user
            begin
                @chat_room_user.update!(appearance: false, last_seen: DateTime.current)
                @chat_room = ChatRoom.find(params[:id])
                AppearancesChannel.broadcast_to(@chat_room, {username: current_user.username, appearance: false}.to_json)
                render json: nil, status: :ok
            rescue => exception
            render json: nil, status: 500 
            end 
        else
            render json: nil, status: :not_found
        end
    end

    def typing
    #called when a user is typing in a chat room. 
    #The broadcasted data can be used to display to users who are currently in the chat room any users who are typing 
    @chat_room = ChatRoom.find(params[:id])
    AppearancesChannel.broadcast_to(@chat_room, {username: current_user.username, typing: true}.to_json)
    TypingIndicatorNotificationJob.perform_now(current_user.id, @chat_room.id)
    render json: nil, status: :ok
    end


    def not_typing
    #called when a user has finished typing 
    #used to update the typing status of users who were previously typing in the chat room
    @chat_room = ChatRoom.find(params[:id])
    AppearancesChannel.broadcast_to(@chat_room, {username: current_user.username, typing: false}.to_json)
    render json: nil, status: :ok
    end
end