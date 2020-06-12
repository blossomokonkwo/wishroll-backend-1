class AddBookmarkCountToRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :bookmark_count, :integer, :default => 0, null: false
    #Ex:- :default =>''
  end
end
