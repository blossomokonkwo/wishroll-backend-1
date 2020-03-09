class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.boolean :hot_topic
      t.string :title

      t.timestamps
    end
  end
end
