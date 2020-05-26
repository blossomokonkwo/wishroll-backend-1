class AddMetaDataToPosts < ActiveRecord::Migration[6.0]
  def change
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :posts, :content_type, :string
    
    add_column :rolls, :content_type, :string
  end
end
