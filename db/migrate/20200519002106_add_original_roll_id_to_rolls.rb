class AddOriginalRollIdToRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :original_roll_id, :bigint, :foreign_key => true, :null => true
    #Ex:- :null => false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
