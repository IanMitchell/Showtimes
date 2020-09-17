json.(@group, :name, :acronym)

json.shows @group.active_fansubs do |fansub|
  current_release = fansub.current_release
  next if current_release.nil?

  json.name fansub.name
  json.season current_release.season

  json.episode do
    json.current current_release.number
    json.airdate current_release.air_date
    json.total fansub.last_episode.number
    json.updated_at current_release.updated_at
  end

  json.partial! 'staff/staff', release: current_release
end
