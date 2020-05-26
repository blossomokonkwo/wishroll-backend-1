class AddRollToTags < ActiveRecord::Migration[6.0]
  def change
    add_reference :tags, :roll, null: true, foreign_key: true
  end
end
