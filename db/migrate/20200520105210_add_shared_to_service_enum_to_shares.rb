class AddSharedToServiceEnumToShares < ActiveRecord::Migration[6.0]
  def change
    add_column :shares, :shared_service, :integer, :default => 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
