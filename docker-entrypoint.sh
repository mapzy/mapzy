#!/bin/bash

# This is the docker start script for the development environment.
# It should execute all necessary steps to present you a nice and
# fresh application.

# Exit immediately when a non-zero return value occurs.
set -e

# Check if pid file exists and remove it on every startup, because it
# might block the startup process.
test -f tmp/pids/server.pid && rm tmp/pids/server.pid

# Set the dev environment (should be the default).
export RAILS_ENV=development

# Install node packages
yarn install

# Set up dev database
bundle exec rake db:create 
bundle exec rake db:migrate
bundle exec rake db:seed

# Set up test database
bundle exec rake db:drop RAILS_ENV=test
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:schema:load RAILS_ENV=test
bundle exec rake db:test:prepare RAILS_ENV=test

# Start rails server
# Note: the port should be the same as within the docker compose file
exec bundle exec rails server -b 0.0.0.0 -p 3000