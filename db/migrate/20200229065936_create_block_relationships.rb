class CreateBlockRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :block_relationships do |t|
      t.bigint :blocker_id, null: false, foreign_key: true
      t.bigint :blocked_id, null: false, foreign_key: true
      t.timestamps
    end
  
  end
end
