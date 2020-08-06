class AddUniqueIndicesToLikes < ActiveRecord::Migration[6.0]
  def change
    add_index :likes, [:likeable_type, :likeable_id, :user_id], unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
