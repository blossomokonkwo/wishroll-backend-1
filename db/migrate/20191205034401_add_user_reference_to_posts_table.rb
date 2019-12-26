class AddUserReferenceToPostsTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :tags, :post, foreign_key: true
    add_reference :posts, :user, foreign_key: true
  end
end
