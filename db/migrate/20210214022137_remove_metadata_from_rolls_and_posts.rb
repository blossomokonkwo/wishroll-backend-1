class RemoveMetadataFromRollsAndPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :rolls, :metadata
    remove_column :posts, :metadata
  end
end
