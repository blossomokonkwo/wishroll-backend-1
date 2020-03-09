class AddUniqueToChatRoomUsers < ActiveRecord::Migration[6.0]
  def change
   add_index :chat_room_users, [:user_id, :chat_room_id], :unique => true
   #Ex:- add_index("admin_users", "username")
  end
end
