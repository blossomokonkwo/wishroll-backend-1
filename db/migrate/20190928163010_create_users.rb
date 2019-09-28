class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.text    :bio, limit: 50

      t.timestamps
    end
    add_index :users, :email, name: "email"
  end
end
