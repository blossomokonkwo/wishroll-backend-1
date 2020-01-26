class RemovePostIdColumnFromLikesTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :likes, :post_id
  end
end
