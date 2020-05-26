class ChangeMediaNamesInPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts, :posts_media_url, :media_url
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    rename_column :posts, :thumbnail_image_url, :thumbnail_url
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
