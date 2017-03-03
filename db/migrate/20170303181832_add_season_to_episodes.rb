class AddSeasonToEpisodes < ActiveRecord::Migration
  def change
    add_reference :episodes, :season, index: true, foreign_key: true
  end
end
