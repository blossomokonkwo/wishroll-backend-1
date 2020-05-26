class AddIndicesToRollsAndColumns < ActiveRecord::Migration[6.0]
  def change
    add_index :rolls, :media_url
    add_index :rolls, :thumbnail_url
    add_index :posts, :media_url
    add_index :posts, :thumbnail_url
    #Ex:- add_index("admin_users", "username")
  end
end
