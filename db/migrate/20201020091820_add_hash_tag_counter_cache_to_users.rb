class AddHashTagCounterCacheToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :total_num_hashtags, :bigint, null: false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :total_num_mentions, :bigint, null: false, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    add_column :users, :total_mentioned_count, :bigint, null: false, default: 0
  end
end
