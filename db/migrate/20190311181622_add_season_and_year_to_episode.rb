class AddSeasonAndYearToEpisode < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :season, :integer
    add_column :episodes, :year, :integer
    remove_column :episodes, :season_id
    drop_table :seasons
  end
end
