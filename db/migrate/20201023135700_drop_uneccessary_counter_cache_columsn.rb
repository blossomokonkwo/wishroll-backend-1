class DropUneccessaryCounterCacheColumsn < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :total_num_likes
    remove_column :users, :post_likes_count
    remove_column :users, :total_num_shares
    remove_column :users, :post_shares_count
    remove_column :users, :total_num_searches
    remove_column :users, :post_bookmarks_count
    remove_column :users, :total_num_bookmarks
    remove_column :users, :total_num_views
    remove_column :users, :total_num_comments
    remove_column :users, :post_comments_count
    remove_column :users, :total_num_rolls
    remove_column :users, :total_num_posts
    remove_column :users, :roll_likes_count
    remove_column :users, :roll_bookmarks_count
    remove_column :users, :roll_shares_count
    remove_column :users, :roll_comments_count
    remove_column :users, :roll_views_count
    remove_column :users, :total_num_hashtags
    remove_column :users, :total_mentioned_count
    remove_column :users, :total_num_created_mentions
    remove_column :users, :total_num_mentioned
    remove_column :posts, :content_type
  end
end
