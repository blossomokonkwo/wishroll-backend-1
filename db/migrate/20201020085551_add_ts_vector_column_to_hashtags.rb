class AddTsVectorColumnToHashtags < ActiveRecord::Migration[6.0]
  def change
    add_column :hashtags, :tsv_text, :tsvector
  end
end
