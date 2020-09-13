class RemoveTvdbNameFromShows < ActiveRecord::Migration[5.2]
  def change
    remove_column :shows, :tvdb_name
  end
end
