class AddPostUrlToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :post_url, :string, null: true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
