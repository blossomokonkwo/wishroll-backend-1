class CreateTrendingtags < ActiveRecord::Migration[6.0]
  def change
    create_table :trending_tags do |t|
      t.string :text, null: false
      t.timestamps
    end
    add_index :trending_tags, :text, unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
