class AddUniquenessConstraintToUsernameAndEmailColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :username, :string, :unique => true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :users, :email, :string, :unique => true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
