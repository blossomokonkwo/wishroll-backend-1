class RecreateSearchTable < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :query, :null => false
      #Ex:- :null => false
      t.bigint :occurences, :default => 1, null: false
      #Ex:- :default =>''

      t.integer :result_type, :default => 0
      #Ex:- :default =>''
    
      t.timestamps
    end
    add_index :searches, [:query, :result_type], :unique => true
    #Ex:- add_index("admin_users", "username")
  end
end
