class DropFriendsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :friends_table
  end
end
