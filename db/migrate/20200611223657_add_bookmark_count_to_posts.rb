class AddBookmarkCountToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :bookmark_count, :integer, :default => 0, null: false
    #Ex:- :default =>''
  end
end
