class RemoveUneccessarySearchColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :searches, :searchable_type
    remove_column :searches, :searchable_id
    add_column :searches, :result_type, :int, default: 0
  end
end
