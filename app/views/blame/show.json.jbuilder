json.(@group, :name, :acronym)

json.name @fansub.name
json.season @release.season
json.episode @release.number
json.air_date @release.air_date.to_datetime
json.updated_at @release.updated_at.to_datetime

json.partial! 'staff/staff', release: @release
