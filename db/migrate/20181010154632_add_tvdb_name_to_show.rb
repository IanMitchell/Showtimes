class AddTvdbNameToShow < ActiveRecord::Migration[5.1]
  def change
    add_column :shows, :tvdb_name, :string
  end
end
