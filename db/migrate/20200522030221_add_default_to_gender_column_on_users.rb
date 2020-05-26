class AddDefaultToGenderColumnOnUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :gender, :integer, default: 2
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
