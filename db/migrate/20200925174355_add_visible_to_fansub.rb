class AddVisibleToFansub < ActiveRecord::Migration[6.0]
  def change
    add_column :fansubs, :visible, :boolean, default: true
  end
end
