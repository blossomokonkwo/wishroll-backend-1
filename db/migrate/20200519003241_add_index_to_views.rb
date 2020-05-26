class AddIndexToViews < ActiveRecord::Migration[6.0]
  def change
    add_index :views, :viewable_id
    #Ex:- add_index("admin_users", "username")
  end
end
