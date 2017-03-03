class RemoveSeasonFromShow < ActiveRecord::Migration
  def change
    remove_reference :shows, :season, index: true
  end
end
