class AddAgeColumnToUsersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :birth_date, :date
    #Ex:- :default =>''
    #Ex:- :null => false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
