class AddLikesCountToRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :likes_count, :bigint
  end
end
