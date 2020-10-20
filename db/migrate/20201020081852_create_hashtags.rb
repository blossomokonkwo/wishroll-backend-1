class CreateHashtags < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    create_table :hashtags do |t|
      t.references :hashtaggable, polymorphic: true
      t.references :user, :null => false
      t.text :text, null: false
      t.uuid :uuid, :null => false, default: 'gen_random_uuid()'
      t.timestamps
    end
    add_index :hashtags, [:user_id, :hashtaggable_id, :hashtaggable_type, :text], unique: true, name: "index_hashtags_on_user_id_hashtaggable"
  end
end
