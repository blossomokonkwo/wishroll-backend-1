class CreateBookmarks < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    create_table :bookmarks do |t|
      t.references :bookmarkable, polymorphic: true
      t.references :user, :null => false
      t.uuid :uuid, :null => false, default: 'gen_random_uuid()'
      t.timestamps
    end
    add_index :bookmarks, [:user_id, :bookmarkable_id, :bookmarkable_type], :unique => true, :name => "index_on_user_id_and_bookmarkable"
  end
end
