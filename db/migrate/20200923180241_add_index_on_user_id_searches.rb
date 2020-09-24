class AddIndexOnUserIdSearches < ActiveRecord::Migration[6.0]
  def change
    add_index :searches, [:user_id, :query, :result_type], unique: true
    #Ex:- add_index("admin_users", "username")
    add_index :searches, :user_id
    #Ex:- add_index("admin_users", "username")
    remove_index :searches, name: "index_searches_on_query_and_result_type"
  end
end
