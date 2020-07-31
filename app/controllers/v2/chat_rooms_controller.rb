class V2::ChatRoomsController < ApplicationController
    before_action :authorize_by_access_header!
    def index
      limit = 10
      offset = params[:offset]
      @chat_rooms = current_user.chat_rooms.order(updated_at: :desc).offset(offset).limit(limit)
      if @chat_rooms.any?
        render :index, status: :ok
      else
        render json: nil, status: :not_found
      end 
    end



    def create
        begin
            @chat_room = current_user.created_chatrooms.create!
            if @chat_room
                @chat_room.users << current_user
                params[:user_ids].each do |user_id|
                    @chat_room.users << User.fetch(user_id)
                end
                render :create, status: :created
            else
                render json: nil, status: 500
            end 
        rescue => exception
            render json: nil, status: 500
        end
    end

    def appear
        #called when a user first appears in a chat room. The users appearance data is then broadcasted to all the other chat room members.
        #The broadcasted data can be used to display to users the active users in the chat room
        @chat_room_user = ChatRoomUser.find_by(user_id: current_user.id, chat_room_id: params[:id])
        if @chat_room_user
          @chat_room_user.appearance = true
          @chat_room_user.last_seen = DateTime.current
          @chat_room_user.save
          @chat_room = ChatRoom.find(params[:id])
          AppearancesChannel.broadcast_to(@chat_room, {username: current_user.username, appearance: true}.to_json)
          render json: nil, status: 200
        else
          render text: "Not Found", status: 404
        end
      end

      def disappear
        #called when a user exits the chat room page of a chat room. The broad cast helps viewing users to be updated in real time when another user is no longer active in a chat room
        @chat_room_user = ChatRoomUser.find_by(user_id: current_user.id, chat_room_id: params[:id])
        if @chat_room_user
          @chat_room_user.appearance = false
          @chat_room_user.save
          @chat_room = ChatRoom.find(params[:id])
          AppearancesChannel.broadcast_to(@chat_room, {username: current_user.username, appearance: false}.to_json)
          render json: nil, status: 200
        else
          render text: "Not Found", status: 404
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