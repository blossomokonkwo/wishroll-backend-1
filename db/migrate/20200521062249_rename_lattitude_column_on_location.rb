class RenameLattitudeColumnOnLocation < ActiveRecord::Migration[6.0]
  def change
    rename_column :locations, :lattitude, :latitude
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
