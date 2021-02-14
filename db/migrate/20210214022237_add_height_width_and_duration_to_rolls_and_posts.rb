class AddHeightWidthAndDurationToRollsAndPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :rolls, :width, :decimal, default: 0.0, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :rolls, :height, :decimal, default: 0.0, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :rolls, :duration, :decimal, default: 0.0, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :posts, :width, :decimal, default: 0.0, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :posts, :height, :decimal, default: 0.0, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :posts, :duration, :decimal, default: 0.0, null: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
