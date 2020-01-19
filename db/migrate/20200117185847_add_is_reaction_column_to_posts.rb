class AddIsReactionColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :original_post_id
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
