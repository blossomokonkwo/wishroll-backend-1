class AddCounterCacheStatsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :total_num_likes, :bigint, :null => false, default: 0 #represents the total number of likes that the user has created
    #Ex:- :null => false
    add_column :users, :likes_count, :bigint, null: false, default: 0 #represents the current number of likes that the user has recieved through rolls and posts
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :total_num_shares, :bigint, :null => false, default: 0 #represents the total number of shares that the user has created
    #Ex:- :null => false
    add_column :users, :share_count, :bigint, :null => false, default: 0 #represents the current number of shares that the user has recieved through rolls and posts
    #Ex:- :null => false
    add_column :users, :total_num_searches, :bigint, :null => false, default: 0 #represents the total number of searches that the user has created
    #Ex:- :null => false
    add_column :users, :bookmark_count, :bigint, :null => false, default: 0 #represents the current number of bookmarks that the user has recieved through rolls and posts
    #Ex:- :null => false
    add_column :users, :total_num_bookmarks, :bigint, :null => false, default: 0 #represents the total number of bookmarks that the users has created
    #Ex:- :null => false
    add_column :users, :total_num_views, :bigint, :null => false, default: 0 #represents the total number of views that the user has created
    #Ex:- :null => false
    add_column :users, :total_num_comments, :bigint, :null => false, default: 0 #represents the total number of comments that the user has created
    #Ex:- :null => false
    add_column :users, :comments_count, :bigint, :null => false, default: 0 #represents the current number of comments that the user has recieved through rolls and posts
    #Ex:- :null => false
    add_column :users, :total_num_rolls, :bigint, :null => false, default: 0 #represents the total number of rolls that the user has created
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :total_num_posts, :bigint, :null => false, default: 0 #represents the total number of posts that the user has created
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
