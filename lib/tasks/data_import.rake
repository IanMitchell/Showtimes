require 'csv'

namespace :data_import do
  task :import_csv => :environment do
    puts 'Checking for CSV files...'

    Dir.glob(File.dirname(__FILE__) + '/../assets/csv/**/*.csv').each do |f|
      puts "Importing file: #{f}"

      CSV.foreach(f, headers: true) do |row|
        @show = Show.find_by(name: row['NAME'])
        if @show.nil?
          puts "No show for #{row['NAME']}. Creating record..."
          @season = Season.find_by(name: Season.names[row['SEASON'].split(' ')[0].downcase],
                                   year: row['SEASON'].split(' ')[1])
          @show = Show.create(name: row['NAME'], season: @season)
          puts "Created record for #{@season.full_name}"
        end

        @fansub = Fansub.find_by(group: Group.first, show: @show)
        if @fansub.nil?
          puts "No fansub for #{row['NAME']}. Creating record..."
          @fansub = Fansub.create(group: Group.first,
                                  show: @show,
                                  tag: row['TAG'],
                                  nyaa_link: row['NYAA'])
        end

        @episode = @show.episodes.where(number: row['EPISODE']).first
        if @episode.nil?
          puts "No episode for #{row['NAME']}. Creating record..."

          if row['AIR']
            month = row['AIR'].split('/')[0].to_i
            day = row['AIR'].split('/')[1].to_i
            year = row['AIR'].split('/')[2].split(' @ ')[0].to_i
            hour = row['AIR'].split(' @ ')[1].split(' ')[0][0...2].to_i
            minute = row['AIR'].split(' @ ')[1].split(' ')[0][2...4].to_i

            # Japan is weird
            if hour >= 24
              hour -= 24
              day += 1
            end

            puts "Parsing date... #{month}/#{day}/#{year}, #{hour}:#{minute} +9"
            air_date = DateTime.new(year, month, day, hour, minute, 0, '+9')
            puts air_date
          else
            air_date = @show.episodes.where(number: row['EPISODE'].to_i - 1).first.air_date + 7.days
          end

          @episode = Episode.create(show: @show,
                                    number: row['EPISODE'],
                                    air_date: air_date)
        end

        @station = Station.find_by(name: row['CHANNEL']) # TODO: Rename row to STATION
        if @station.nil?
          puts "No station found for #{row['CHANNEL']}. Creating station..."
          @station = Station.create(name: row['CHANNEL'])
        end

        @release = @fansub.releases.where(source: @episode).first
        if @release.nil?
          puts "No release for episode #{@episode.number}. Creating release..."
          @release = Release.create(fansub: @fansub,
                                    station: @station,
                                    source: @episode,
                                    released: !row['RELEASE'].nil?)
        end

        [:TL, :TLC, :ENC, :ED, :TM, :TS, :QC].each do |position|
          next if row[position.to_s].nil?

          @position = Position.find_by(acronym: position.to_s)

          # Handle multiple users
          row[position.to_s].split(', ').each do |name|
            next if row[position.to_s].eql? 'N/A'

            @user = User.find_by(name: name)

            if @user.nil?
              puts "No account for #{name}. Creating a default account..."
              @user = User.create(email: "#{name}@test.com",
                                  password: 'password',
                                  name: name,
                                  irc_nick: row[position.to_s],
                                  twitter: 'Unknown')
              @member = Member.create(group: Group.first, user: @user)
            end

            @staff = Staff.find_by(user: @user, position: @position, release: @release)
            if @staff.nil?
              puts "Adding #{name} to Episode #{@episode.number} staff..."
              @staff = Staff.create(user: @user,
                                    position: @position,
                                    release: @release,
                                    finished: @release.released)
            end
          end
        end
      end
    end

    puts 'Done!'
  end
end
