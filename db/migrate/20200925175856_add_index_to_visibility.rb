class AddIndexToVisibility < ActiveRecord::Migration[6.0]
  def change
    add_index :fansubs, :visible
  end
end
