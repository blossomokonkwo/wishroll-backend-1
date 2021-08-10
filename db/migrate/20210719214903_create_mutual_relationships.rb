class CreateMutualRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :mutual_relationships do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :mutual_id, null: false, foreign_key: true
      t.timestamps
    end
    add_foreign_key :mutual_relationships, :users, column: :mutual_id
    add_index :mutual_relationships, :mutual_id
    add_index :mutual_relationships, [:mutual_id, :user_id], unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
