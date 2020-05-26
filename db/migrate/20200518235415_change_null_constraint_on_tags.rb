class ChangeNullConstraintOnTags < ActiveRecord::Migration[6.0]
  def change
    change_column :tags, :post_id, :bigint, :null => true
    #Ex:- :null => false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
