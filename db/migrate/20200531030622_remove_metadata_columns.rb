class RemoveMetadataColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :aspect_ratio
  end
end
