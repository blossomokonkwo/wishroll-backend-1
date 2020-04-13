class AddIndexOnTagsText < ActiveRecord::Migration[6.0]
  def change
    add_index :tags, :text
    #Ex:- add_index("admin_users", "username")
  end
end
