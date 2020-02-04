class ChangePriceColumnInWishes < ActiveRecord::Migration[6.0]
  def change
    change_column :wishes, :price, :decimal, :default => 0.00, scale: 2, precision: 8, null: false
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
