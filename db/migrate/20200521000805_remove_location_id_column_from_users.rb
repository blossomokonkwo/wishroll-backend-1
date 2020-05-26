class RemoveLocationIdColumnFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :location_id
  end
end
