class AddViewCountToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :total_view_count, :bigint, :default => 0, null: false
    #Ex:- :default =>''
  end
end
