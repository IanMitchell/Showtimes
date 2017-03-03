json.(@group, :name, :acronym)

json.shows @group.fansubs.active do |fansub|
  next if fansub.current_release.nil?

  json.name fansub.show.name

  json.episode do
    json.current fansub.current_release.source.number
    json.season fansub.current_release.source.season.full_name
    json.airdate fansub.current_release.source.air_date
    json.total fansub.show.episodes.count
    json.updated_at fansub.current_release.updated_at
    json.station fansub.current_release.station.name
  end

  json.status fansub.current_release.staff do |staff|
    json.position staff.position.name
    json.acronym staff.position.acronym
    json.staff staff.user.name
    json.finished staff.finished
  end
end
