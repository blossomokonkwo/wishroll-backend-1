class RemoveDeviceTokenColumnFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :device_token
  end
end
