class DefaultHotTopicColumnOnTopicsToFalse < ActiveRecord::Migration[6.0]
  def change
    change_column :topics, :hot_topic, :boolean, default: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
