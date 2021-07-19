class CreateMutualRelationshipRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :mutual_relationship_requests do |t|
      t.bigint :requesting_user_id, null: false, foreign_key: :true
      t.bigint :requested_user_id, null: false, foreign_key: true
      t.boolean :accepted

      t.timestamps
    end

    add_index :mutual_relationship_requests, :requesting_user_id
    add_index :mutual_relationship_requests, :requested_user_id
    add_index :mutual_relationship_requests, [:requested_user_id ,:requesting_user_id], unique: true, name: "index_mutual_relationship_requests_users_uniqueness"
    #Ex:- add_index("admin_users", "username")
  end
end
