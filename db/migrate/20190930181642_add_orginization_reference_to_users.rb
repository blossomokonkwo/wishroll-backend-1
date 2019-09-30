class AddOrginizationReferenceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :orginization_id, :integer
    add_foreign_key :users, :orginizations
  end
end
