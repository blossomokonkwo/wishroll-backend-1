class CreateFriendsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :friends_table do |t|
      t.references :user, name: "user_id"
      t.date :added_at
    end
  end
end
