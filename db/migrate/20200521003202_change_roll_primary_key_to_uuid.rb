class ChangeRollPrimaryKeyToUuid < ActiveRecord::Migration[6.0]
  def change
    remove_column :searches, :searhable_id 
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    add_column :searches, :searchable_id, :bigint
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)

    add_index :searches, :created_at
    #Ex:- add_index("admin_users", "username")
  end
end
