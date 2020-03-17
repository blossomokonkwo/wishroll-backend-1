class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    #when a user is subscribed to a particular chatroom's channel, they recieve all the messages that are sent to that chat room. 
    #The user subscribes to this channel when they are 
    @chat_room = ChatRoom.find(params[:chat_room_id])
    if @chat_room.users.include?(current_user)
      stream_for @chat_room
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end