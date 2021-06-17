class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.bigint :user_count, null: false, default: 0
      t.string :name, null: false
      t.text :description
      t.string :banner_media_url

      t.timestamps
    end
    
    add_index :boards, :name, unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
