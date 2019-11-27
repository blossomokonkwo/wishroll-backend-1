class UpdateDateColumInFriendsTable < ActiveRecord::Migration[6.0]
  def change
    change_column :friends_table, :added_at, :datetime, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
