class RemoveMentionCounterCache < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :total_num_mentions
  end
end
