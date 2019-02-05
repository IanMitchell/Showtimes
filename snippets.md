# Add New Episode to Airing Show

```ruby
# Retrieve Show
@show = Show.fuzzy_search('Show Name').first

# Create new Episode
@episode = Episode.create(
  show: @show,
  number: @show.episodes.count + 1,
  air_date: @show.episodes.last.air_date + 1.week,
  season: @show.episodes.last.season
)

# Create Release
@fansub = @show.fansubs.first
@last_release = @fansub.releases.last

@release = Release.create(
  fansub: @fansub,
  station: @last_release.station,
  episode: @episode,
  released: false
)

# Attach Staff
@last_release.staff.each do |staff|
  Staff.create(
    user: staff.user,
    position: staff.position,
    release: @release,
    finished: false
  )
end
```

# Change Season of Episodes

```ruby
# Retrieve Show
@show = Show.fuzzy_search('Show Name').first

@show.episodes.each do |episode|
  if episode.number >= 13
    episode.season = Season.current
    episode.save
  end
end
```
