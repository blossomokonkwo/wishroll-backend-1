class AddEmailToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :email, :string, null: false, unique: true
    add_index :admin_users, :email
    #Ex:- add_index("admin_users", "username")
  end
end
