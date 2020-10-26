class RemoveNotNullConstraintFromShareSearchAndView < ActiveRecord::Migration[6.0]
  def change
    change_column :views, :user_id, :bigint, null: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :shares, :user_id, :bigint, null: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    change_column :searches, :user_id, :bigint, null: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
