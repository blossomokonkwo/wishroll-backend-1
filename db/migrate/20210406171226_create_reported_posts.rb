class CreateReportedPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :reported_posts do |t|
      t.bigint :user_id, null: false, foreign_key: true
      t.bigint :post_id, null: false, foreign_key: true
      t.integer :reason, null: false, default: 0

      t.timestamps
    end
  end
end
