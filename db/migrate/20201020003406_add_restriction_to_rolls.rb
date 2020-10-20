class AddRestrictionToRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :restricted, :boolean, null: false, default: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_index :rolls, :restricted
    #Ex:- add_index("admin_users", "username")
    add_index :rolls, :private
  end
end
