class RemoveTopicForeignKeyOnChatRoom < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :chat_rooms, :topics
  end
end
