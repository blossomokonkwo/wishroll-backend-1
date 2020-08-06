class AddIndexOnMessagesCreatedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :messages, :created_at
  end
end
