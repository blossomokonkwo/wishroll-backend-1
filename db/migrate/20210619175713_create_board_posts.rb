class CreateBoardPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :board_posts do |t|
      t.references :board_member, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
