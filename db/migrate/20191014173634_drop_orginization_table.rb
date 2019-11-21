require_relative '20190930180111_create_orginizations'
class DropOrginizationTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :orginization_id
   revert CreateOrginizations
  end
end
