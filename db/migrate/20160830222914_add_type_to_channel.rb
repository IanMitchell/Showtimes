class AddTypeToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :platform, :integer, default: 0
  end
end
