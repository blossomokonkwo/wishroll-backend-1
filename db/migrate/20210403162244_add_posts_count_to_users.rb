class AddPostsCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :posts_count, :bigint, default: 0, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
