class RemoveColumnsFromRelationship < ActiveRecord::Migration[6.0]
  def change
    remove_column :relationships, :blocked_user_id
    remove_column :relationships, :blocker_user_id
  end
end
