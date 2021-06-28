class ChangeMediaUrlName < ActiveRecord::Migration[6.1]
  def change
    rename_column :boards, :profile_media_url, :avatar_url
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    rename_column :boards, :banner_media_url, :banner_url
  end
end
