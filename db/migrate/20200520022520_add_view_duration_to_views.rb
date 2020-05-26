class AddViewDurationToViews < ActiveRecord::Migration[6.0]
  def change
    add_column :views, :duration, :float
  end
end
