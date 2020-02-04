class AddNameToWishlists < ActiveRecord::Migration[6.0]
  def change
    add_column :wishlists, :name, :string, :null => false
    #Ex:- :null => false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
