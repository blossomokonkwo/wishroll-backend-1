class AddFollowersCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :followers_count, :bigint, :default => 0
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :following_count, :bigint, :default => 0
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
