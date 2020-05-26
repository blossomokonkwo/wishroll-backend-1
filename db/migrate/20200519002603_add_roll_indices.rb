class AddRollIndices < ActiveRecord::Migration[6.0]
  def change
    add_index :rolls, :original_roll_id
    #Ex:- add_index("admin_users", "username")
  end
end
