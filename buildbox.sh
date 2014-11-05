#!/bin/bash
set -e

echo '--- bundling'
bundle

echo '--- preparing database'
./bin/rake db:create
./bin/rake db:schema:load

echo '--- running tests'
./bin/rake test
