class AddBoardIdToPostsAndDeleteBoardPostTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :board_posts
    add_reference :posts, :board, null: true
    #Ex:- add_index("admin_users", "username")
  end
end
