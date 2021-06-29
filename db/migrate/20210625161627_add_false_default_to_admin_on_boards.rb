class AddFalseDefaultToAdminOnBoards < ActiveRecord::Migration[6.1]
  def change
    change_column :board_members, :admin, :boolean, default: false, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
