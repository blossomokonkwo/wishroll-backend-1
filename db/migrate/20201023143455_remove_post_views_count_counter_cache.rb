class RemovePostViewsCountCounterCache < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :post_views_count
  end
end
