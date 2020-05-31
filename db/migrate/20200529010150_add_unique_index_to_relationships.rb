class AddUniqueIndexToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_index :relationships, [:followed_id, :follower_id], :unique => true
    #Ex:- add_index("admin_users", "username")
  end
end
