class AppearancesChannel < ApplicationCable::Channel
  def subscribed
    #the appearance channel handles the appearance of a user in a specified chat room  
    @chat_room = ChatRoom.find(params[:chat_room_id]) #find the specified chat room that hosts the appearances coordination
    if @chat_room.users.include?(current_user) #if the current user is a member of the chat room, then they can are authorized to recieve and send appearance messages
      stream_for @chat_room
    else
      reject
    end 
  end

  def unsubscribed
    stop_all_streams
  end

end
