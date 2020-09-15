class ChangeTheRollsTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :rolls, :thumbnail_gif_url
    remove_column :rolls, :original_roll_id
    remove_column :rolls, :reactions_count
    remove_column :rolls, :content_type
    remove_column :rolls, :private
    add_column :rolls, :featured, :boolean, default: false, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    remove_column :rolls, :album_id
  end
end
