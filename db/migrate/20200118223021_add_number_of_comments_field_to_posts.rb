class AddNumberOfCommentsFieldToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :number_of_comments, :bigint, :default => 0, null: false
    #Ex:- :default =>''
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
