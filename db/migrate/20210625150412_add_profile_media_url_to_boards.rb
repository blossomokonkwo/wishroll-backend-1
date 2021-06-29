class AddProfileMediaUrlToBoards < ActiveRecord::Migration[6.1]
  def change
    add_column :boards, :profile_media_url, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
