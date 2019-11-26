class AddSecondForeignKeyToFriendsTable < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :friends_table, :users, column: :user_id
  end
end
