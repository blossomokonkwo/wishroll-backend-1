class ChangeSearchesResultTypeColumn < ActiveRecord::Migration[6.0]
  def change
    if foreign_key_exists?(:views, :users)
      remove_foreign_key :views, :users
    end
    if foreign_key_exists?(:shares, :users)
      remove_foreign_key :shares, :users
    end
    if foreign_key_exists?(:searches, :users)
      remove_foreign_key :searches, :users
    end
    change_column :searches, :result_type, :integer, null: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    remove_index :shares, name: "index_shares_on_user_id_and_shareable_id"
  end
end
