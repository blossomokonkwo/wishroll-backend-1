class AddIndexOnFullName < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :full_name
    #Ex:- add_index("admin_users", "username")
  end
end
