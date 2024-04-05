# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 7.1.3.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.5.5"
# Use Puma as the app server
gem "puma", "~> 6.4.1"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.11.5"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Authentication
gem "devise", "~> 4.9.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.18.3", require: false

# Useful information for every country in the ISO 3166 standard
gem "countries", "~> 6.0.0"

# Forward & reverse geocoder
gem "geocoder", "~> 1.8.2"

gem "importmap-rails", "~> 2.0.1"

# Hotwired
gem "stimulus-rails", "~> 1.3.3"
gem "turbo-rails", "~> 2.0.4"

gem "stripe", "~> 10.9.0"

gem "foreman", "~> 0.87.2"

gem "mailpace-rails", "~> 0.3.2"

gem "solid_queue", "~> 0.3.0"

gem "faraday", "~> 2.9.0"

# Utility to use short hash IDs instead of the database IDs
gem "hashid-rails", "~> 1.4"

gem "tailwindcss-rails", "~> 2.2.1"

gem "activerecord-import", "~> 1.5.1"

# Sentry to monitor production errors
gem "sentry-rails"
gem "sentry-ruby"

gem "sprockets-rails", "~> 3.4.2"

gem "mission_control-jobs", "~> 0.2.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]

  # Tests with rspec
  gem "rspec-rails", "~> 6.1.0"

  # Factories
  gem "factory_bot_rails", "~> 6.4.0"

  # Run specs automatically with guard
  gem "guard-rspec", require: false

  # Linting with rubocop
  gem "rubocop", "~> 1.60.2"
  gem "rubocop-performance", "~> 1.20.2"
  gem "rubocop-rails", "~> 2.23.1"
  gem "rubocop-rspec", "~> 2.26.1"

  # Manage env variables with dotenv
  gem "dotenv-rails", "~> 3.0.2"

  # Security checks
  gem "brakeman", "~> 6.1.2", require: false
  gem "bundler-audit", "~> 0.9.1", require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs
  # for each request in your browser.
  # Can be configured to work on production as well see:
  # https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem "spring"

  # Preview emails in the browser
  gem "letter_opener", "~> 1.9.0"

  gem "annotate", "~> 3.2.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 3.40.0"
  gem "selenium-webdriver", "~> 4.18.1"

  # Helpers for test
  gem "shoulda-matchers", "~> 6.1.0"

  gem "webmock", "~> 3.22.0"

  gem "database_cleaner-active_record", "~> 2.1.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
