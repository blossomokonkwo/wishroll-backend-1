class AddUniqueIndexToqueryAndResultType < ActiveRecord::Migration[6.0]
  def change
    add_index :searches, [:result_type, :query], :unique => true
    #Ex:- add_index("admin_users", "username")
  end
end
