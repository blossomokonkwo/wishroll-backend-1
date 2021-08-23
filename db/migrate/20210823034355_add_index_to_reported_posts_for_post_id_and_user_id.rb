class AddIndexToReportedPostsForPostIdAndUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :reported_posts, :post_id
    add_index :reported_posts, :user_id
    #Ex:- add_index("admin_users", "username")
  end
end
