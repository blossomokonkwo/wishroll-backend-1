class AddColumnsToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :activity_phrase, :string, :null => false
    #Ex:- :null => false
    add_column :activities, :content_id, :bigint, :null => false
    #Ex:- :null => false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
