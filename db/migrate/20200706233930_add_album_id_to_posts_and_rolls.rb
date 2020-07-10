class AddAlbumIdToPostsAndRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :album_id, :bigint
    add_column :posts, :album_id, :bigint
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
