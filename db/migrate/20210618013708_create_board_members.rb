class CreateBoardMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :board_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.boolean :admin, null: false, defualt: false

      t.timestamps
    end
    add_index :board_members, [:user_id, :board_id], unique: true
    add_index :board_members, :admin
    #Ex:- add_index("admin_users", "username")
  end
end
