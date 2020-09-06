class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.string :media_url
      t.string :thumbnail_url
      t.timestamps
    end
  end
end
