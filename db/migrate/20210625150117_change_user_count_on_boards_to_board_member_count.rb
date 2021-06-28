class ChangeUserCountOnBoardsToBoardMemberCount < ActiveRecord::Migration[6.1]
  def change
    rename_column :boards, :user_count, :board_member_count
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
