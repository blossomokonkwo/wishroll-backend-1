class AddThumbnailUrlToAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :thumbnail_url, :string
  end
end
