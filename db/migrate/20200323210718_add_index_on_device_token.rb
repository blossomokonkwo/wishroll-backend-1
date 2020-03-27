class AddIndexOnDeviceToken < ActiveRecord::Migration[6.0]
  def change
    add_index :devices, :device_token
    #Ex:- add_index("admin_users", "username")
  end
end
