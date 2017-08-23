json.(@group, :name, :acronym)

json.name @fansub.show.name
json.season @release.episode.season.full_name
json.episode @release.episode.number
json.air_date @release.episode.air_date.to_datetime
json.updated_at @release.updated_at.to_datetime

json.status @release.staff do |staff|
  json.position staff.position.name
  json.acronym staff.position.acronym
  json.staff staff.user.name
  json.finished staff.finished
end
