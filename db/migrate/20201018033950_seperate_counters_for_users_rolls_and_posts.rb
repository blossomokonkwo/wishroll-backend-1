class SeperateCountersForUsersRollsAndPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :likes_count, :post_likes_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    rename_column :users, :bookmark_count, :post_bookmarks_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    rename_column :users, :share_count, :post_shares_count
    rename_column :users, :comments_count, :post_comments_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    rename_column :users, :view_count, :post_views_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    add_column :users, :roll_likes_count, :bigint, :null => false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :roll_bookmarks_count, :bigint, :null => false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :roll_shares_count, :bigint, :null => false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :roll_comments_count, :bigint, :null => false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :roll_views_count, :bigint, :null => false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
