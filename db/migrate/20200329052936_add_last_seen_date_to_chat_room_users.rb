class AddLastSeenDateToChatRoomUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_room_users, :last_seen, :datetime
  end
end
