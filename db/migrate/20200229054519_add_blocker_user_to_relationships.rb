class AddBlockerUserToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_column :relationships, :blocker_user_id, :bigint
    change_column :relationships, :blocked_user_id, :bigint
    add_index :relationships, :blocker_user_id
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
