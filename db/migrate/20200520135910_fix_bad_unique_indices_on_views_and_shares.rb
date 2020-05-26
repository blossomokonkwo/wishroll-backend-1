class FixBadUniqueIndicesOnViewsAndShares < ActiveRecord::Migration[6.0]
  def change
    remove_index :views, name: :index_views_on_user_id_and_viewable_id
    remove_index :shares, :name => "index_shares_on_shareable_type_and_shareable_id"
    add_index :views, [:user_id, :viewable_id, :viewable_type], :unique => true

    add_index :shares, [:user_id, :shareable_id, :shareable_type], unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
