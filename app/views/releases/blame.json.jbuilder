json.(@group, :name, :acronym)

json.name @fansub.show.name
json.season @fansub.show.season.full_name
json.episode @release.source.number
json.airdate @release.source.air_date.to_datetime
json.updated_at @release.updated_at.to_datetime

json.status @release.staff do |staff|
  json.position staff.position.name
  json.acronym staff.position.acronym
  json.staff staff.user.name
  json.status staff.status
end
