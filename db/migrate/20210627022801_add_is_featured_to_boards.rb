class AddIsFeaturedToBoards < ActiveRecord::Migration[6.1]
  def change
    add_column :boards, :featured, :boolean, null: false, default: false
    add_index :boards, :featured
    add_index :boards, :uuid
    #Ex:- add_index("admin_users", "username")
  end
end
