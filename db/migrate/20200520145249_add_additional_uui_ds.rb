class AddAdditionalUuiDs < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    add_column :comments, :uuid, :uuid, :default => 'gen_random_uuid()', null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :activities, :uuid, :uuid, :default => 'gen_random_uuid()', null: false
    #Ex:- :default =>''
    add_column :locations, :uuid, :uuid, :default => 'gen_random_uuid()', null: false
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
