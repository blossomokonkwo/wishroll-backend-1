class CreateRolls < ActiveRecord::Migration[6.0]
  def change
    create_table :rolls do |t|
      t.string :media_url
      t.references :user, null: false, foreign_key: true
      t.bigint :view_count, :default => 0
      t.string :caption
      t.bigint :comments_count, default: 0
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
