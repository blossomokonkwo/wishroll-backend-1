class CreateOrginizations < ActiveRecord::Migration[5.2]
  def change
    create_table :orginizations do |t|
      t.string :name
      t.integer :users_count

      t.timestamps
    end
  end
end
