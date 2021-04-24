class AddUniqueIndexToReportedPostsAndBlockRelationships < ActiveRecord::Migration[6.1]
  def change
    add_index :reported_posts, [:post_id, :user_id], unique: true
    add_index :block_relationships, [:blocker_id, :blocked_id], unique: true
    #Ex:- add_index("admin_users", "username")
    #Ex:- add_index("admin_users", "username")
  end
end
