class ChangeMetadataType < ActiveRecord::Migration[6.1]
  def change
    change_column :rolls, :width, :float, default: 0.0, null: false
    change_column :rolls, :height, :float, default: 0.0, null: false
    change_column :rolls, :duration, :float, default: 0.0, null: false
    change_column :posts, :width, :float, default: 0.0, null: false
    change_column :posts, :height, :float, default: 0.0, null: false
    change_column :posts, :duration, :float, default: 0.0, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
