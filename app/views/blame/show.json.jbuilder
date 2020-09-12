json.(@group, :name, :acronym)

json.name @fansub.show.name
json.tvdb_name @fansub.show.tvdb_name unless @fansub.show.tvdb_name.nil?
json.season @release.episode.season
json.episode @release.episode.number
json.air_date @release.episode.air_date.to_datetime
json.updated_at @release.updated_at.to_datetime

json.partial! 'staff/staff', release: @release
