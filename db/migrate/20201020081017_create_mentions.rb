class CreateMentions < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    create_table :mentions do |t|
      t.references :mentionable, polymorphic: true
      t.references :user, :null => false
      t.references :mentioned_user, null: false
      t.uuid :uuid, :null => false, default: 'gen_random_uuid()'
      t.timestamps
    end
    add_index :mentions, [:user_id, :mentionable_id, :mentionable_type, :mentioned_user_id], :unique => true, name: "index_mentions_on_user_id_and_mentionable"
    #Ex:- add_index("admin_users", "username")
  end
end
