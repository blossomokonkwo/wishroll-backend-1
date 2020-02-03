class CreateWishlists < ActiveRecord::Migration[6.0]
  def change
    create_table :wishlists do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :wishes_count, default: 0
      t.bigint :total_amount_raised, default: 0

      t.timestamps
    end
  end
end
