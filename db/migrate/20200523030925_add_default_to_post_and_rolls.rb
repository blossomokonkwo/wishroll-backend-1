class AddDefaultToPostAndRolls < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :share_count, :bigint, default: 0
    change_column :rolls, :share_count, :bigint, default: 0
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
