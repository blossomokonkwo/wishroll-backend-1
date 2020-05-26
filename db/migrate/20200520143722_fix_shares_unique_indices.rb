class FixSharesUniqueIndices < ActiveRecord::Migration[6.0]
  def change
    remove_index :shares, name: :index_shares_on_user_id_and_shareable_id_and_shareable_type
    add_index :shares, [:user_id, :shareable_id, :shareable_type, :shared_service], unique: true, name: "index_unique_share" 
    #Ex:- add_index("admin_users", "username")
  end
end
