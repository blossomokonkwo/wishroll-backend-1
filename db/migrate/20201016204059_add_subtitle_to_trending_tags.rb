class AddSubtitleToTrendingTags < ActiveRecord::Migration[6.0]
  def change
    add_column :trending_tags, :description, :text
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    rename_column :trending_tags, :text, :title
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
