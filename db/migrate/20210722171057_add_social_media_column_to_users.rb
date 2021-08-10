class AddSocialMediaColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :social_media, :jsonb
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_index :users, :social_media, using: 'gin'
    #Ex:- add_index("admin_users", "username")
  end
end
