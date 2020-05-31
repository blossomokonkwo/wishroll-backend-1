class DropSearchIdColumnFromLocations < ActiveRecord::Migration[6.0]
  def change
    remove_column :locations, :search_id
  end
end
