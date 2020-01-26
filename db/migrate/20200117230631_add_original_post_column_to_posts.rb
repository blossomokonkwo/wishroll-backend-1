class AddOriginalPostColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :original_post_id_id
    add_reference :posts, :original_post 
  end
end
