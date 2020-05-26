class RemoveOriginalCommentIdFromPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :original_post_id
  end
end
