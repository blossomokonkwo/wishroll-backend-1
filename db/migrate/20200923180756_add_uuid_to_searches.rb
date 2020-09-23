class AddUuidToSearches < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    add_column :searches, :uuid, :uuid, null: false, default: 'gen_random_uuid', after: :id 
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_index :searches, :uuid, unique: true
    #Ex:- add_index("admin_users", "username")
    
    change_column :searches, :user_id, :bigint, references: true, null: false, after: :uuid
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
