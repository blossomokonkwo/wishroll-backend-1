class AddProfileBackgroundUrlToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :profile_picture_url, :avatar_url
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")

    add_column :users, :profile_background_url, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
