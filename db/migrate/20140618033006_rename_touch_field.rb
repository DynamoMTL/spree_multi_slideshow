class RenameTouchField < ActiveRecord::Migration
  def change
    rename_column :spree_slideshows, :touch, :touch_enabled
  end
end
