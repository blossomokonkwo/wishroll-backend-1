class ChangeThumbnailImageUrlNameInPosts < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :thumbnail_image_url, :string, :name => "thumbnail_url"
    #Ex:- change_column("admin_users", "email", :string, :limit =>25
  end
end
