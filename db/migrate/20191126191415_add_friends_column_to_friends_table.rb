class AddFriendsColumnToFriendsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :friends_table, :friend_id, :integer, :null => false
    #Ex:- :null => false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
