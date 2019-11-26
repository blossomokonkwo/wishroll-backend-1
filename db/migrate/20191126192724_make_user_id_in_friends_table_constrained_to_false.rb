class MakeUserIdInFriendsTableConstrainedToFalse < ActiveRecord::Migration[6.0]
  def change
    change_column :friends_table, :user_id, :bigint, :null => false
    #Ex:- :null => false 
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
