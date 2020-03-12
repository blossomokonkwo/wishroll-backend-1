class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    #when a user is subscribed to a particular chatroom's channel, they recieve all the messages that are sent to that chat room. 
    #The user subscribes to this channel when they are 
    @chat_room = ChatRoom.find(params[:chat_room_id])
    unless @chat_room.num_users > 0 && @chat_room.users.exists?(id: current_user.id)
      reject
    else
      stream_for @chat_room
    end

  end

  def unsubscribed
    
  end
end