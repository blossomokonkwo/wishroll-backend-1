class AddThumbnailUrlToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :thumbnail_url, :string
  end
end
