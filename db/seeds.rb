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
  { name: 'Timer', acronym: 'TM' },
  { name: 'Typesetter', acronym: 'TS' },
  { name: 'Quality Control', acronym: 'QC' }
])
