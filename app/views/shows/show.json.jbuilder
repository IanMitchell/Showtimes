json.name @show.name

unless @show.aliases.empty?
  json.alias @show.aliases.first.name
end

if @show.next_episode
  json.episode_number @show.next_episode.number
  json.air_date @show.next_episode.air_date
end
