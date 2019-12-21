class AddViewCountToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :view_count, :bigint, after: :id, default: 0, null: false
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
