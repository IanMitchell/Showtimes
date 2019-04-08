json.(@group, :name, :acronym)

json.shows @group.active_fansubs do |fansub|
  next if fansub.current_release.nil?

  json.name fansub.show.name
  json.tvdb_name fansub.show.tvdb_name unless fansub.show.tvdb_name.nil?
  json.season fansub.current_release.episode.season

  json.episode do
    json.current fansub.current_release.episode.number
    json.airdate fansub.current_release.episode.air_date
    json.total fansub.show.episodes.count
    json.updated_at fansub.current_release.updated_at
  end

  json.status fansub.current_release.staff do |staff|
    json.position staff.position.name
    json.acronym staff.position.acronym
    json.staff staff.member.name
    json.finished staff.finished
  end
end
