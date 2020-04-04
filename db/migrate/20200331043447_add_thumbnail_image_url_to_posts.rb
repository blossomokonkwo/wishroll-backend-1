class AddThumbnailImageUrlToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :thumbnail_image_url, :string
  end
end
