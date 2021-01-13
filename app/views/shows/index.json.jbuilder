json.shows @shows do |show|
  next if show.next_episode.nil?

  json.id show.id
  json.name show.name

  unless show.terms.empty?
    json.term show.terms.first.name
  end

  json.episode_number show.next_episode.number
  json.air_date show.next_episode.air_date
end
