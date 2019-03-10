class AddIndexToCoreModels < ActiveRecord::Migration[5.2]
  def change
    add_index :channels, :discord
    add_index :aliases, :name
    add_index :shows, :name
    add_index :users, :discord
    add_index :positions, :name
    add_index :positions, :acronym
  end
end
