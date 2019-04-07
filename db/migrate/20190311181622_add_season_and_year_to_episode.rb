class AddSeasonAndYearToEpisode < ActiveRecord::Migration[5.2]
  def change
    remove_column :episodes, :season_id, :integer
    drop_table :seasons
  end
end
