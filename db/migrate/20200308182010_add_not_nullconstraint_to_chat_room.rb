class AddNotNullconstraintToChatRoom < ActiveRecord::Migration[6.0]
  def change
    change_column :chat_rooms, :creator_id, :bigint, null: false
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
