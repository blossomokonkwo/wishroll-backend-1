class AddMediaUrlToTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :media_url, :string
  end
end
