class RenameMispelledColumnsOnLocation < ActiveRecord::Migration[6.0]
  def change
    rename_column :locations, :locatable_id, :locateable_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    rename_column :locations, :locatable_type, :locateable_type
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
