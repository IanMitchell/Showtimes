# Make Stations
Station.create([
  { name: 'AT-X' },
  { name: 'BS-Fuji' },
  { name: 'BS-TBS' },
  { name: 'BS11' },
  { name: 'Crunchyroll' },
  { name: 'Daisuki' },
  { name: 'Fuji TV' },
  { name: 'Funimation' },
  { name: 'KBS' },
  { name: 'MBS' },
  { name: 'SUN TV' },
  { name: 'TBS' },
  { name: 'TV Aichi' },
  { name: 'TV Asahi' },
  { name: 'TV Tokyo' },
  { name: 'TVK' },
  { name: 'TVS' },
  { name: 'Tokyo MX' },
  { name: 'WOWOW' },
  { name: 'Yomiuri TV' },
])

# Make Seasons
(2010..2025).each do |year|
  [:winter, :spring, :summer, :fall].each do |season|
    Season.create(name: season, year: year)
  end
end

# Make Positions
Position.create([
  { name: 'Translator', acronym: 'TL' },
  { name: 'Translator Check', acronym: 'TLC' },
  { name: 'Encoder', acronym: 'ENC' },
  { name: 'Editor', acronym: 'ED' },
  { name: 'Timer', acronym: 'TI' },
  { name: 'Typesetter', acronym: 'TS' },
  { name: 'Quality Control', acronym: 'QC' }
])

# Make Groups
Group.create([
  {
    name: 'Good Job! Media',
    acronym: 'GJM'
  }
])

Channel.create([
  {
    name: '#goodjob',
    group: Group.first
  },
  {
    name: '#gjm-dev',
    group: Group.first,
    staff: true
  },
  {
    name: '#goodjobclub',
    group: Group.first,
    staff: true
  }
])

# Make Users
desch = User.create(name: 'Desch', email: 'test@test.com', password: 'password')
fyurie = User.create(name: 'Fyurie', email: 'test2@test.com', password: 'password')

# Make Members
Member.create([
  { group: Group.first, user: User.first, title: 'Technowizard', role: 2 },
  { group: Group.first, user: User.second, title: 'Taskmaster', role: 2 }
])

# Make a Show
show = Show.new(season: Season.first, name: "Desch's Slice of Life", link: nil)
Alias.create(name: 'AOTY', show: show)
fansub = Fansub.new(group: Group.first, show: show)
(1..12).each do |ep|
  Episode.create(show: show, number: ep, air_date: Time.now - (15 - ep.days))
  rel = Release.create(fansub: fansub,
                       station: Station.first,
                       source: Episode.find(ep),
                       released: ep < 6 ? 1 : 0)

  Staff.create([
    { user: desch, release: rel, position: Position.first },
    { user: fyurie, release: rel, position: Position.second },
    { user: fyurie, release: rel, position: Position.last, finished: 1 }
  ])
end
