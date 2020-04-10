class AddMutedToChatRoomUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_room_users, :muted, :bool, :default => false
    #Ex:- :default =>''
  end
end
