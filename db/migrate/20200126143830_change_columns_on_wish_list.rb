class ChangeColumnsOnWishList < ActiveRecord::Migration[6.0]
  def change
    change_column :wishes, :price, :float, :scale => 2, :default => 0.00, comment: "The price for a wish"
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :wishes, :amount_covered, :float, :scale => 2, :default => 0.00, comment: "The amount covered so far for a specific wish"
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :wishlists, :total_amount_raised, :float, :scale => 2, :default => 0.00, comment: "This column stores the total caches the total amount of money raised for all wishes in a users wishlist"
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
