class RemoveLinkFromShows < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :link, :string
  end
end
