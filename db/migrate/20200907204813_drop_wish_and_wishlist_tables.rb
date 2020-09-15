class DropWishAndWishlistTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :wishes
    drop_table :wishlists
  end
end
