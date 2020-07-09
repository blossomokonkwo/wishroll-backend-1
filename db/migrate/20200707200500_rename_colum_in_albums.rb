class RenameColumInAlbums < ActiveRecord::Migration[6.0]
  def change
    rename_column :albums, :albumable_count, :post_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
