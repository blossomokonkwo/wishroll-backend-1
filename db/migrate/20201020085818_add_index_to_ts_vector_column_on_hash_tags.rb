class AddIndexToTsVectorColumnOnHashTags < ActiveRecord::Migration[6.0]
  def up 
    execute "create index hashtags_tsvtext on hashtags using gin(tsv_text)"
  end

  def down 
    execute "drop index hashtags_tsvtext"
  end
end
