class AddIndicesToBlockRelationships < ActiveRecord::Migration[6.0]
  def change
    add_index :block_relationships, :blocked_id
    #Ex:- add_index("admin_users", "username")
    add_index :block_relationships, :blocker_id
    #Ex:- add_index("admin_users", "username")
  end
end
