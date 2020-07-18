class AddIndexOnPosts < ActiveRecord::Migration[6.0]
  def change
    add_index :posts, :caption
    #Ex:- add_index("admin_users", "username")
  end
end
