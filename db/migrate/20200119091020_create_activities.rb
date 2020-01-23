class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :active_user_id, null: false, foreign_key: true
      t.string :activity_type

      t.timestamps
    end
  end
end
