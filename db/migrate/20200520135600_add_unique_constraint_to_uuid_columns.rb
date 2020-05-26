class AddUniqueConstraintToUuidColumns < ActiveRecord::Migration[6.0]
  def change

    remove_index :users, name: :index_users_on_username
    add_index :users, :username, unique: true
    #Ex:- add_index("admin_users", "username")
    add_index :posts, :uuid

    add_index :rolls, :uuid

    add_index :tags, :uuid
    #Ex:- add_index("admin_users", "username")
  end
end
