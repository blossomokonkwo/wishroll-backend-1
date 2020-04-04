class CreateUserBlockedPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_blocked_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.string :reason, null: false

      t.timestamps
    end
  end
end
