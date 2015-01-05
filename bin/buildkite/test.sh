#!/bin/bash
set -e

echo '--- bundling'
bundle install --without development doc

echo '--- preparing database'
./bin/rake db:create RAILS_ENV=test

echo '--- running tests'
./bin/rake test
