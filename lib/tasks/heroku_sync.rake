require 'net/http'

# TODO: These are a little tailored right now for my heroku setup. Should try
# to make them more generalized.
namespace :heroku_db do
  task :import => :environment do
    puts 'Importing Heroku Database...'
    puts 'Creating backup...'
    system 'heroku pg:backups capture --app showtimes'
    puts 'Downloading backup...'
    system 'curl -o heroku_backup.dump `heroku pg:backups public-url`'
    puts 'Restoring DB'
    system 'rake db:drop'
    system 'pg_restore heroku_backup.dump'
    puts 'Done!'
  end

  task :export => :environment do
    puts 'Exporting Database...'
    system 'pg_dump showtimes_development --format=c > showtimes.dump'

    # TODO: Swap out for FTP script
    puts 'Upload showtimes.dump to a server and input URL:'
    url = gets.chomp

    system "heroku pg:backups restore '#{url}' DATABASE_URL --confirm showtimes"
    puts 'Done!'
  end
end
