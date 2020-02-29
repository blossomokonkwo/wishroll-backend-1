class AddCommentsToRelationships < ActiveRecord::Migration[6.0]
  def change
    change_column :relationships, :blocked_user_id, :bigint, comment: "References the id of the user that was blocked"
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :relationships, :blocker_user_id, :bigint, comment: "References the id of the user that initiated the blocking"
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
