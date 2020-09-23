class ChangeUuidColumnInSearches < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    change_column :searches, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- add_index("admin_users", "username")
  end
end
