class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    #when a user is subscribed to a particular chatroom's channel, they recieve all the messages that are sent to that chat room. 
    #The user subscribes to this channel when they are 
    @chat_room = ChatRoom.find(params[:chat_room_id])
    reject unless @chat_room.users.count > 0 && @chat_room.users.exists?(id: current_user.id)
    stream_for @chat_room

  end

  def unsubscribed
    
  end
end