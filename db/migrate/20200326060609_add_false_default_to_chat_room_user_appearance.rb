class AddFalseDefaultToChatRoomUserAppearance < ActiveRecord::Migration[6.0]
  def change
    change_column :chat_room_users, :appearance, :bool, :default => false
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
