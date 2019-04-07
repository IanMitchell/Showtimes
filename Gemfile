source 'https://rubygems.org'

ruby '2.5.3'

gem 'rails', '5.2.2'
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
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# APIs
gem 'jbuilder', '~> 2.0'

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

group :doc do
  gem 'sdoc', '~> 0.4.0', group: :doc
end
