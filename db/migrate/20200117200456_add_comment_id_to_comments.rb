class AddCommentIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :original_comment
  end
end
