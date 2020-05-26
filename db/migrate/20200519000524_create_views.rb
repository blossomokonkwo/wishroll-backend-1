class CreateViews < ActiveRecord::Migration[6.0]
  def change
    create_table :views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :viewable, polymorphic: true
      t.timestamps
    end
  end
end
