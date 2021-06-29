class AddPostsCountCounterCacheToBoards < ActiveRecord::Migration[6.1]
  def change
    add_column :boards, :posts_count, :bigint, null: false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_index :boards, :posts_count
    #Ex:- add_index("admin_users", "username")
  end
end
