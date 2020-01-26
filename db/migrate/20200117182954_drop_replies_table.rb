class DropRepliesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :replies
  end
end
