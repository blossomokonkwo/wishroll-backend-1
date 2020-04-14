class AddIndexToChatRoomName < ActiveRecord::Migration[6.0]
  def change
    add_index :chat_rooms, :name
    #Ex:- add_index("admin_users", "username")
  end
end
