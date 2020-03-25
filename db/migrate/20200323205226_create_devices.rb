class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :device_token
      t.string :platform

      t.timestamps
    end
  end
end
