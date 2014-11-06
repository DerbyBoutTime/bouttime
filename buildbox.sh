#!/bin/bash
set -e

echo '--- bundling'
bundle

echo '--- preparing database'
./bin/rake db:create db:schema:load RAILS_ENV=test

echo '--- running tests'
./bin/rake test
