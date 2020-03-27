class AppearancesChannel < ApplicationCable::Channel
  def subscribed
    #the appearance channel handles the appearance of a user in a specified chat room  
    @chat_room = ChatRoom.find(params[:chat_room_id]) #find the specified chat room that hosts the appearances coordination
    if chat_room.users.include?(current_user) #if the current user is a member of the chat room, then they can are authorized to recieve and send appearance messages
      stream_for @chat_room
    else
      reject
    end 
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def appearance(args)
    #this action is called by the client when a user has entered a specific chat room
    #the data field is hash that contains information of the users appearance such as the chat room id of the appearance and the timestamp of the appearance
    chat_room_user = ChatRoomUser.find_by(user_id: current_user.id, chat_room_id: args[:chat_room_id])
    if chat_room_user #if the current user is apart of the specified chat room
      chat_room_user.appearance = true
      chat_room_user.save
      chat_room = ChatRoom.find(args[:chat_room_id])
      AppearancesChannel.broadcast_to(chat_room, current_user.username, {appearance: true})
    end
  end

  def disappearance(args)
    #this action is called by the client when a user has left a specific chat room 
    chat_room_user = ChatRoomUser.find_by(user_id: current_user.id, chat_room_id: args[:chat_room_id])
    if chat_room_user
      chat_room_user.appearance = false
      chat_room_user.save
      chat_room = ChatRoom.find(args[:chat_room_id])
      AppearancesChannel.broadcast_to(chat_room, current_user.username, {appearance: false})
    end
  end

  def typing(data)
    #check to see if the typer isn't the current user and the user isn't appearing in the chat room and the user
    #if all of these criteria are met, then send a typing broadcast to all of the users in the app who meet the away criteria.
    #the app should display a typing indicator under the user who is typing on the app to indicate that a specific user is typing for those in the chat room
    chat_room = ChatRoom.find(data[:chat_room_id])
    if typing_user and chat_room
      AppearancesChannel.broadcast_to(chat_room, current_user.username, {typing: true})
    end
    
  end

  def end_typing(data)
    #when the user has ended typing, a broadcast should be sent to indicate that the user has ended typing and that the typing indicator shouldn't be activated under that specific user
    chat_room = ChatRoom.find(data[:chat_room_id])
    if end_typing_user and chat_room
      AppearancesChannel.broadcast_to(chat_room, end_typing_user.username, {typing: false})
    end
  end


end
