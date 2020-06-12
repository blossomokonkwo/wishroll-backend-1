class AddReactionsCountToRolls < ActiveRecord::Migration[6.0]
  def change
    add_column :rolls, :reactions_count, :bigint, :default => 0
    #Ex:- :default =>''
  end
end
