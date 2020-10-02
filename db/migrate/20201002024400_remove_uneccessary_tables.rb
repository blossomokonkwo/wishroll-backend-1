class RemoveUneccessaryTables < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :album_id
    remove_column :users, :roll_count
    drop_table :albums
  end
end
