class AddWishRollScoreToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :wishroll_score, :bigint, :default => 0, :null => false
    #Ex:- :null => false
    #Ex:- :default =>''
  end
end
