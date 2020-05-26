class AddUniqueIndexToLikes < ActiveRecord::Migration[6.0]
  def change
    remove_index :likes, name: :index_likes_on_likeable_type_and_likeable_id
    add_index :likes, [:user_id, :likeable_id, :likeable_type], :unique => true
  end
end
