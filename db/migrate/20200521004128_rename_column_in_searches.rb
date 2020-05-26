class RenameColumnInSearches < ActiveRecord::Migration[6.0]
  def change
    rename_column :searches, :searhable_type, :searchable_type
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
