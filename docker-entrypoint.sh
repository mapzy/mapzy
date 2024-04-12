#!/bin/bash -e
set -e

# create database if it doesn't exist
./bin/rails db:create

# run migrations if necessary
./bin/rails db:migrate

# create initial user if env vars are set and user doesn't exist
if [ -n "${INIT_USER_EMAIL}" ] && [ -n "${INIT_USER_PASSWORD}" ] && [ "$(./bin/rails runner "puts User.exists?(email: '${INIT_USER_EMAIL}')")" = 'false' ]
then
  echo "Creating initial user..."
  ./bin/rails runner "User.create!({email: '${INIT_USER_EMAIL}', password: '${INIT_USER_PASSWORD}', password_confirmation: '${INIT_USER_PASSWORD}' }).create_account.update(status: 'active')"
fi

exec "${@}"

