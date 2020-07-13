class AddRestrictedToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :restricted, :boolean, default: false, nil: false
    add_index :posts, :restricted
    #Ex:- add_index("admin_users", "username")
  end
end
