class ChatRoomsController < ApplicationController
    before_action :authorize_by_access_header!

      def create
          @chatroom = ChatRoom.new(topic_id: params[:topic_id], name: params[:name], creator_id: current_user.id)
          if @chatroom.save
              @chatroom.users << current_user #automatically add the chatroom creator to the his/her created chat room
              render json: nil, status: 201
          else
              render json: {error: "The chatRoom could not be created"}, status: 400
          end
      end

      def index
        @chat_rooms = nil
        @current_user = current_user
        if params[:topic_id].present? #if this is under the topics resource 'topics/:id/chat_rooms', then grab all the chatrooms for that topic
          @chat_rooms = ChatRoom.where(topic_id: params[:topic_id]).order(num_users: :desc, updated_at: :desc)
          @chat_rooms.to_a.sort! do |a,b|
            if a.users.include?(current_user) and b.users.include?(current_user)
              return 0
            elsif a.users.include?(current_user)
              return 1
            elsif b.users.include?(current_user)
                return -1
            else
              return -1 #if the user isn't in neither of the chat rooms we want to maintain the original ordering 
            end
          end
          if @chat_rooms.present?
            render :index, status: 200
          else
            render json: {error: "This topic currently has no chatrooms"}, status: 404
          end
        else #grab all of the current users private chat rooms 
          @chat_rooms = @current_user.chat_rooms
          if @chat_rooms.present?
            render :index, status: 200
          else
            render json: {error: "The current user isn't in any chatrooms"}, status: 404
          end
        end
      end
    


      def show
        @chat_room = ChatRoom.find(params[:id])
        if @chat_room.present?
          render :show, status: 200
        else
          render json: {error: "Chat room Not Found"}, status: 404
        end
      end
    
    
      def update
        #this is called when the current user is joining the chatroom
        @chat_room = ChatRoom.find(params[:id])
        @chat_room.update(update_chat_room)
        render json: nil, status: 200
      end

      def join 
        #called when the current user is joining a chatroom
        chat_room_user = ChatRoomUser.new(user_id: current_user.id, chat_room_id: params[:chat_room_id])
        if chat_room_user.save
            render json: nil, status: 201
        else
            render json: {error: "You were unable to join the chat room "}, status: 400
        end
      end
      
      def leave 
        #called when the current_user is leaving a chat room 
        #the current_user should also be removed as a subscriber to the associated channel. Basically, call the unsubscribed method in the associated channel
        chat_room_user = ChatRoomUser.where(user_id: current_user.id, chat_room_id: params[:chat_room_id])
        if chat_room_user.present?
          if @chat_room_user.destroy
            render json: nil, status: 200
          else 
            render json: {error: "Could not leave chat room"}, status: 400
          end
        else
          render json: {error: "You can't leave a chat room that you are not a member of"}, status: 404
        end
      end

      def destroy
        @chatroom = ChatRoom.find(params[:id])
        if chatroom.creator == current_user
            if @chatroom.destroy
                render json: nil, status: 200
            else
                render json: {error: "Chat was unable to be destroyed"}, status: 400
            end
        else
            render json: {error: "You do not have permission to delete this chatroom"}, status: 401
        end
      end

      private 
      def update_chat_room
        params.permit :name
      end
end
