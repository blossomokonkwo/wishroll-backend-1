class AddCacheCountToCommentsAndPostsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :replies_count, :bigint, :default => 0
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :posts, :comments_count, :bigint, :default => 0
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :comments, :likes_count, :bigint, :default => 0
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :posts, :likes_count, :bigint, :default => 0
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
