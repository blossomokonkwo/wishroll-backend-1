class AddDefaultOfOneToSearches < ActiveRecord::Migration[6.0]
  def change
    change_column :searches, :occurences, :bigint, :default => 1
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
