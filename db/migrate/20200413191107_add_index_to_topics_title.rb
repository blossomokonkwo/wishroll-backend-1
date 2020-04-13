class AddIndexToTopicsTitle < ActiveRecord::Migration[6.0]
  def change
    add_index :topics, :title
    #Ex:- add_index("admin_users", "username")
  end
end
