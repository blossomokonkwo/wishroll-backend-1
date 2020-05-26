class AddDefaultToViews < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    change_column :views, :uuid, :uuid, default: 'gen_random_uuid()', :null => false
    #Ex:- :null => false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
