class DropStoriesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :stories
  end
end
