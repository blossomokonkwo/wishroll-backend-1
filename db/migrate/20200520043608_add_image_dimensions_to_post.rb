class AddImageDimensionsToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :meta_data, :json, :after => :caption
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :rolls, :meta_data, :json, after: :caption
  end
end
