class EditFriendIdcColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :friends_table, :friend_id, :bigint
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
