class CreateMessages < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    create_table :messages do |t|
      t.text :body
      t.string :media_url
      t.references :user, null: false, foreign_key: true
      t.references :chat_room, null: false, foreign_key: true
      t.string :kind
      t.uuid :uuid, :default => 'gen_random_uuid()'
      t.timestamps
    end
      add_index :messages, :uuid
  #Ex:- add_index("admin_users", "username")
  rename_column :messages, :user_id, :sender_id
  #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end


end
