json.(@group, :name, :acronym)

json.shows @group.fansubs.active do |fansub|
  json.name fansub.show.name
  json.season fansub.show.season.full_name

  json.episode do
    json.current fansub.current_release.source.number
    json.airdate fansub.current_release.source.air_date
    json.total fansub.show.episodes.count
  end

  json.status fansub.current_release.staff do |staff|
    json.position staff.position.name
    json.staff staff.user.name
    json.status staff.status
  end
end
