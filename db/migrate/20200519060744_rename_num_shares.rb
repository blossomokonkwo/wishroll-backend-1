class RenameNumShares < ActiveRecord::Migration[6.0]
  def change
    rename_column :rolls, :num_shares, :shares_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    rename_column :posts, :num_shares, :shares_count
  end
end
