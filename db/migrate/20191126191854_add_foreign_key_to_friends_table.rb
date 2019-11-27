class AddForeignKeyToFriendsTable < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :friends_table, :users, column: "friend_id"
  end
end
