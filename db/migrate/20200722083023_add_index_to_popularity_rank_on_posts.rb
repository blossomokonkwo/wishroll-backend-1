class AddIndexToPopularityRankOnPosts < ActiveRecord::Migration[6.0]
  def change
    add_index :posts, :popularity_rank
    #Ex:- add_index("admin_users", "username")
  end
end
