class AddNumberAndAirDateToRelease < ActiveRecord::Migration[6.0]
  def up
    add_column :releases, :number, :integer
    add_column :releases, :air_date, :datetime
    
    Release.all.each do |release|
      release.number = release.episode.number
      release.air_date = release.episode.air_date
      release.save!
    end
  end
  
  def down
    remove_column :releases, :number
    remove_column :releases, :air_date
  end
end
