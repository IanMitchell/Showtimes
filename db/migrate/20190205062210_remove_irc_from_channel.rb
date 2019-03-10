class RemoveIrcFromChannel < ActiveRecord::Migration[5.2]
  def change
    remove_column :channels, :staff
    remove_column :channels, :platform
    rename_column :channels, :name, :discord
  end
end
