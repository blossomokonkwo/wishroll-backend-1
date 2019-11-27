class RemoveIdColumnFromFriendsTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :friends_table, :id
  end
end
