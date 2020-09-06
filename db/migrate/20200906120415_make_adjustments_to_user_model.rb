class MakeAdjustmentsToUserModel < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, name: "email"
    change_column :users, :gender, :integer, null: false, default: 2
    add_index :users, :email, unique: true
    add_index :users, :verified
    #Ex:- add_index("admin_users", "username")
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
