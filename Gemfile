source 'https://rubygems.org'

gem 'rails', '4.2.4'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Admin Interface
gem 'administrate', github: 'thoughtbot/administrate', ref: '476b12f'

# Accounts
gem 'devise'

# Slugs
gem 'friendly_id'

# Front-end
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'foundation-rails'

# APIs
gem 'jbuilder', '~> 2.0'

# Server
# gem 'unicorn'
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :doc do
  gem 'sdoc', '~> 0.4.0', group: :doc
end
