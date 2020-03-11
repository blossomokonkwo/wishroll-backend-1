class ChatRoomsController < ApplicationController
    before_action :authorize_by_access_header!

      def create
          @chatroom = ChatRoom.new(topic_id: params[:topic_id], name: params[:name], creator_id: current_user.id)
          @chatroom.users << current_user #automatically add the chatroom creator to the his/her created chat room
          if @chatroom.save
              render json: nil, status: 201
          else
              render json: {error: "The chatRoom could not be created"}, status: 400
          end
      end

      def index
        @chat_rooms = nil
        if params[:topic_id].present? #if this is under the topics resource 'topics/:id/chat_rooms', then grab all the chatrooms for that topic
          @chat_rooms = ChatRoom.where(topic_id: params[:topic_id]).order(num_users: :desc, updated_at: :desc)
          if @chatrooms.present?
            render :index, status: 200
          else
            render json: {error: "This topic currently has no chatrooms"}, status: 404
          end
        else #grab all of the current users private chat rooms 
          @chat_rooms = current_user.chat_rooms
          if @chat_rooms.present?
            render :index, status: 200
          else
            render json: {error: "The current user isn't in any chatrooms"}, status: 404
          end
        end
      end
    


      def show
        @chatroom = chatrooms.find(params[:id])
        if @chatroom.present?
          render :show, status: 200
        else
          render json: {error: "Chat room Not Found"}, status: 404
        end
      end
    
    
      def update
        #this is called when the current user is joining the chatroom
        @chatroom = ChatRoom.find(params[:id])
        @chatroom.update(update_chat_room)
        render json: nil, status: 200
      end

      def join 
        #called when the current user is joining a chatroom
        @chatroom = ChatRoom.find(params[:chat_room_id])
        @chatroom.users << current_user
        if @chatroom.save
            render json: nil, status: 201
        else
            render json: {error: "You were unable to join this chat room #{@chatroom.name}"}, status: 400
        end
      end
      
      def leave 
        #called when the current_user is leaving a chat room 
        #the current_user should also be removed as a subscriber to the associated channel. Basically, call the unsubscribed method in the associated channel
        @chatroom = ChatRoom.find(params[:chat_room_id])
        @chatroom.users.delete current_user #the current user should only be able to leave the chat rooms that they are currently in.
        #unsubscribe

        
        render json: nil, status: 200
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
