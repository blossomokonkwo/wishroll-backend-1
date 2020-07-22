class CreateStories < ActiveRecord::Migration[6.0]
  def change
    create_table :stories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :media_url
      t.string :thumbnail_url
      t.bigint :view_count, default: 0, :null => false
      #Ex:- :null => false
      t.bigint :share_count, :default => 0, null: false
      #Ex:- :default =>''
      t.bigint :bookmark_count, :default => 0, :null => false
      #Ex:- :null => false
      #Ex:- :default =>''
      t.text :caption
      t.bigint :like_count, default: 0, null: false
      t.float :popularity_rank
      t.boolean :restricted, :null => false, default: false
      #Ex:- :null => false
      t.integer :priority, null: false, default: 0
      t.bigint :comment_count, :null => false, default: 0
      #Ex:- :null => false
      t.datetime :expiration_date

      t.timestamps
    end

    add_index :stories, :popularity_rank
    add_index :stories, :priority
    add_index :stories, :restricted
    add_index :stories, :expiration_date
    #Ex:- add_index("admin_users", "username")
  end
end
