json.(@group, :name, :acronym)

json.name @fansub.show.name
json.season @release.episode.season
json.episode @release.episode.number
json.air_date @release.episode.air_date.to_datetime
json.updated_at @release.updated_at.to_datetime

json.partial! 'staff/staff', release: @release
