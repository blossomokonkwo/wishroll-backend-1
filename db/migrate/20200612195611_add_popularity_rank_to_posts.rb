class AddPopularityRankToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :popularity_rank, :float, :default => 0.0, :null => false
    #Ex:- :null => false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
