class AddAspectRatioColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :aspect_ratio, :float
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    remove_column :posts, :meta_data
    remove_column :rolls, :meta_data
  end
end
