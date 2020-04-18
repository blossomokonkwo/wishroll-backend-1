class AddCurrentDeviceToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :current_device, :bool, :default => false
  end
end
