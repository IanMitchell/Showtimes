# Make Channels
Channel.create([
  { name: 'Tokyo MX' },
  { name: 'TV Tokyo' },
  { name: 'BS11' },
  { name: 'Fuji TV' },
  { name: 'BS-Fuji' },
  { name: 'TV Aichi' },
  { name: 'TV Asahi' },
  { name: 'Yomiuri TV' },
  { name: 'KBS' },
  { name: 'SUN TV' },
  { name: 'AT-X' },
  { name: 'TBS' },
  { name: 'MBS' },
  { name: 'BS-TBS' },
  { name: 'Crunchyroll' },
  { name: 'Funimation' },
  { name: 'Daisuki' },
  { name: 'WOWOW' },
  { name: 'TVK' },
  { name: 'TVS' },
])

# Make Seasons
(2010..2020).each do |year|
  [:winter, :spring, :summer, :fall].each do |season|
    Season.create(name: season, year: year)
  end
end


# Make Groups
Group.create([
  { name: 'Good Job Media', acronym: 'GJM', irc: '#goodjob' }
])

# Make Users

# Make Members

# Make a Show
