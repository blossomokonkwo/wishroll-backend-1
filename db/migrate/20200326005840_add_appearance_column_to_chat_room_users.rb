class AddAppearanceColumnToChatRoomUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_room_users, :appearance, :bool
  end
end
