class AdditionalColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string, limit: 20, unique: true
    add_column :users, :first_name, :string, limit: 20, null: false, :default => "First"
    add_column :users, :last_name, :string, limit: 20, null: false, default: "Last"
    add_column :users, :is_verified, :boolean, null: false, default: false
  end
end
