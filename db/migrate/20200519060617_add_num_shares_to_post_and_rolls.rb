class AddNumSharesToPostAndRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :num_shares, :bigint, :default => 0
    #Ex:- :default =>''
    add_column :posts, :num_shares, :bigint, :defualt => 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
