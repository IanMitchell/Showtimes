source 'https://rubygems.org'

ruby '2.7.2'

gem 'rails', '6.0.3'
gem 'bootsnap'
gem 'puma'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Security
gem 'rack-attack'

# Slugs
gem 'friendly_id'

# CORS
gem 'rack-cors'

# Admin Interface
gem 'trestle'
gem 'trestle-search'
gem 'trestle-auth'
gem 'cocoon'

# Alerts
gem 'discord-notifier'

# Front-end
gem 'sass-rails'
gem 'uglifier'

# APIs
gem 'jbuilder'

# Metrics
gem "skylight"

# Server
# gem 'unicorn'
# gem 'capistrano-rails', group: :development

# Database
gem 'pg'
gem 'unicorn'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'dotenv-rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Database
  gem 'annotate'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'listen'
end
