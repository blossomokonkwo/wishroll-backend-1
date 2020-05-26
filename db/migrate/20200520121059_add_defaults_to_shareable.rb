class AddDefaultsToShareable < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :shares_count, :bigint, :default => 0
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)

    rename_column :posts, :shares_count, :shared_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")

    change_column :rolls, :shares_count, :bigint, :default => 0
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)

    rename_column :rolls, :shares_count, :shared_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
