class AddUniqueConstraintToUsername < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :username, :string, :unique => true, :null => false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)

    rename_column :users, :is_verified, :verified
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")

    rename_column :users, :full_name, :name
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")

    rename_column :users, :total_view_count, :view_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")

    change_column :users, :email, :string, :unique => true, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)

    change_column :users, :birth_date, :date, :null => false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)

  end
end
