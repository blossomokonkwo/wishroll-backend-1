class AddIndicesToVariousModels < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :username
    #Ex:- add_index("admin_users", "username")
  end
end
