class CreateWishes < ActiveRecord::Migration[6.0]
  def change
    create_table :wishes do |t|
      t.bigint :price
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.string :image_url
      t.string :product_name, null: false
      t.bigint :amount_covered, default: 0

      t.timestamps
    end
  end
end
