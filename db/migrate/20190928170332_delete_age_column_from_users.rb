class DeleteAgeColumnFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :age
    #why? Because we don't need to save data on our users age; we just need to know that they are atleast 13 years old
  end
end
