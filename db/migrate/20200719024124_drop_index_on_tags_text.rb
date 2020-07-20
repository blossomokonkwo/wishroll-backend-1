class DropIndexOnTagsText < ActiveRecord::Migration[6.0]
  def change
    remove_index :tags, name: "index_tags_on_text"
    remove_index :tags, name: "tags_text"
  end
end
