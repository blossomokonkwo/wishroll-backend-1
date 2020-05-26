class ChangeColumnNameInActivities < ActiveRecord::Migration[6.0]
  def change
    rename_column :activities, :post_url, :media_url
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
