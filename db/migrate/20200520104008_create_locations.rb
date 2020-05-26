class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :locatable, polymorphic: true
      t.float :lattitude
      t.decimal :longitude
      t.string :city
      t.string :country
      t.string :ip
      t.string :region
      t.string :timezone
      t.integer :postal_code

      t.timestamps
    end

    add_index :locations, :longitude
    #Ex:- add_index("admin_users", "username")

    add_index :locations, :lattitude
    add_index :locations, :country
    add_index :locations, :city    
  end
end
