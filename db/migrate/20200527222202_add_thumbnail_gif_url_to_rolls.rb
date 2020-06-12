class AddThumbnailGifUrlToRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :thumbnail_gif_url, :string
  end
end
