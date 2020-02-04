class ChangeContentIdTableInActivities < ActiveRecord::Migration[6.0]
  def change
    change_column :activities, :content_id, :bigint, :null => true
    #Ex:- :null => false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
