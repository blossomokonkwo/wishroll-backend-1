class AddConfirmPasswordToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :confirm_password_digest, :string, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")

    change_column :admin_users, :password_digest, :string, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
