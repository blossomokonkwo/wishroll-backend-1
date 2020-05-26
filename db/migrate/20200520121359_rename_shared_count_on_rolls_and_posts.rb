class RenameSharedCountOnRollsAndPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :rolls, :shared_count, :share_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")

    rename_column :posts, :shared_count, :share_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
