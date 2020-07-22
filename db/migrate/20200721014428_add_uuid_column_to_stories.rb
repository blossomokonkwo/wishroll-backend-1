class AddUuidColumnToStories < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    add_column :stories, :uuid, :uuid, :default => 'gen_random_uuid', null: false
    add_index :stories, :uuid
    #Ex:- add_index("admin_users", "username")
    #Ex:- :default =>''
  end
end
