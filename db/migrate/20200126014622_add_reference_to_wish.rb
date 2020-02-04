class AddReferenceToWish < ActiveRecord::Migration[6.0]
  def change
    add_reference :wishes, :wishlist, foreign_key: true
  end
end
