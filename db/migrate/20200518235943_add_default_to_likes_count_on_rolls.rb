class AddDefaultToLikesCountOnRolls < ActiveRecord::Migration[6.0]
  def change
    change_column :rolls, :likes_count, :bigint, :default => 0
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
