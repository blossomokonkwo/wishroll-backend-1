class AddIndexToTsVectorColumnOnTags < ActiveRecord::Migration[6.0]
  def up 
    execute "create index tags_tsvtext on tags using gin(tsv_text)"
  end

  def down 
    execute "drop index tags_tsvtext"
  end
end
