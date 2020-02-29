class AddBlockedUsersToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_column :relationships, :blocked_user_id, :bigint
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_index :relationships, :blocked_user_id
    #Ex:- add_index("admin_users", "username")
  end
end
