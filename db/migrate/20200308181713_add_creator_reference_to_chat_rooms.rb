class AddCreatorReferenceToChatRooms < ActiveRecord::Migration[6.0]
  def change
    add_reference :chat_rooms, :user, null: true, foreign_key: true
    rename_column :chat_rooms, :user_id, :creator_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
