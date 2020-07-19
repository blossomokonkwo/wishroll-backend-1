class AddIndexToTagsText < ActiveRecord::Migration[6.0]
  def up
    execute "create index tags_text on tags using gin(to_tsvector('english', text))"
  end

  def down 
    execute "drop index tags_text"
  end
end
