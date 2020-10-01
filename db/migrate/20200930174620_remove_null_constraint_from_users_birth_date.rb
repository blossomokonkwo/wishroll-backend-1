class RemoveNullConstraintFromUsersBirthDate < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :birth_date, :date, null: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
