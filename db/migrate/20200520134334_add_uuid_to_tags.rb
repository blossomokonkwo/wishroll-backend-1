class AddUuidToTags < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    add_column :tags, :uuid, :uuid, :default => 'gen_random_uuid()', :null => false
    #Ex:- :null => false
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
