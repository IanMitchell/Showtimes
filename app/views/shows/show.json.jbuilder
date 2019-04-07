json.name @show.name
json.tvdb_name @show.tvdb_name unless @show.tvdb_name.nil?

unless @show.terms.empty?
  json.term @show.terms.first.name
end

if @show.next_episode
  json.episode_number @show.next_episode.number
  json.air_date @show.next_episode.air_date
end
