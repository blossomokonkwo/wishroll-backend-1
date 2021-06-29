class ChangeAdminOnBoardMemebersToIsAdmin < ActiveRecord::Migration[6.1]
  def change
    rename_column :board_members, :admin, :is_admin
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
