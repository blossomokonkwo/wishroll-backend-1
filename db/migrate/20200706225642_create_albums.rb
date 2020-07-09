class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.references :user
      t.string :name
      t.boolean :private
      t.bigint :albumable_count

      t.timestamps
    end
    add_index :albums, :name
    #Ex:- add_index("admin_users", "username")
  end
end
