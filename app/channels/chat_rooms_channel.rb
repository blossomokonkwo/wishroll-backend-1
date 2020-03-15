class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    #when a user is subscribed to a particular chatroom's channel, they recieve all the messages that are sent to that chat room. 
    #The user subscribes to this channel when they are 
    @chat_room = ChatRoom.find(params[:chat_room_id])
    puts "#{@chat_room}\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    stream_for @chat_room
  end

  def unsubscribed
    stop_all_streams
  end
end