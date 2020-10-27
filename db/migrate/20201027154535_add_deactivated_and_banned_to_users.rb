class AddDeactivatedAndBannedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :banned, :boolean, null: false, default: false
    add_column :users, :deactivated, :boolean, null: false, default: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_index :users, :banned
    add_index :users, :deactivated
    #Ex:- add_index("admin_users", "username")
  end
end
