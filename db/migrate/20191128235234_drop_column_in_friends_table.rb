class DropColumnInFriendsTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :friends_table, :added_at
    add_column :friends_table, :created_at, :datetime, null: :false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
