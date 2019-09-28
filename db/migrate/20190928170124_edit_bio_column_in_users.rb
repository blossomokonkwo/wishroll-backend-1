class EditBioColumnInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :bio, :text, :limit => 100
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
