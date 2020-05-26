class AddUuidToViewsAndShares < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    add_column :views, :uuid, :uuid, :default => 'gen_random_uuid', null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :shares, :uuid, :uuid, :default => 'gen_random_uuid', null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")

    add_index :views, :uuid
    add_index :shares, :uuid
    add_index :views, [:user_id, :viewable_id], unique: true
    add_index :shares, [:user_id, :shareable_id], unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
