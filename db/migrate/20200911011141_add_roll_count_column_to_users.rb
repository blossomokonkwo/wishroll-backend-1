class AddRollCountColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :roll_count, :bigint, null: false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
