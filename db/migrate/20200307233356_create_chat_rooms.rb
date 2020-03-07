class CreateChatRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_rooms do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :name
      t.bigint :num_users

      t.timestamps
    end
  end
end
