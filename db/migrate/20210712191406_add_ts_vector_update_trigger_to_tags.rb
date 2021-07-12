class AddTsVectorUpdateTriggerToTags < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
    CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
    ON tags FOR EACH ROW EXECUTE PROCEDURE
    tsvector_update_trigger(tsv_text, 'pg_catalog.english', text);
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE tags SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON tags
    SQL
  end
  
end
