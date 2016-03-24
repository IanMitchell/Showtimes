json.shows @shows do |show|
  next if show.next_episode.nil?
  
  json.name show.name
  json.alias show.aliases.first.name
  json.episode_number show.next_episode.number
  json.air_date show.next_episode.air_date
end
