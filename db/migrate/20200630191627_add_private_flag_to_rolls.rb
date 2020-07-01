class AddPrivateFlagToRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :private, :boolean, :default => false, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
