class AddDefaultToPrivateOnAlbums < ActiveRecord::Migration[6.0]
  def change
    change_column :albums, :private, :boolean, default: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
