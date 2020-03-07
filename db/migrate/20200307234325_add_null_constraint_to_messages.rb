class AddNullConstraintToMessages < ActiveRecord::Migration[6.0]
  def change
    change_column :messages, :uuid, :string, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :messages, :kind, :string, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :chat_rooms, :topic_id, :bigint, null: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
