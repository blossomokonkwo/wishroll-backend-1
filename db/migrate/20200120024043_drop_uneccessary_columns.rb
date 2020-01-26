class DropUneccessaryColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :number_of_comments
    remove_column :comments, :replies_count
  end
end
