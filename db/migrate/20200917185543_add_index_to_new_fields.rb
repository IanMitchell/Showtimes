class AddIndexToNewFields < ActiveRecord::Migration[6.0]
  def change
    add_index :fansubs, :name
    
    add_index :releases, :number
    add_index :releases, :air_date
  end
end
