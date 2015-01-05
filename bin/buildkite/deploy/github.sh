#!/bin/bash

if ! gem list octokit -v 3.7.0 -i &> /dev/null; then
  echo '--- installing dependencies'
  gem install octokit -v 3.7.0 --user-install --no-rdoc --no-ri
fi

echo '--- running github_deployment.rb'
./bin/buildkite/deploy/github.rb
