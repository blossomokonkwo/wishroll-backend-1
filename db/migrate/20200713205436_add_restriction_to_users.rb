class AddRestrictionToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :restricted, :boolean, default: false, nil: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_index :users, :restricted
    #Ex:- add_index("admin_users", "username")
  end
end
