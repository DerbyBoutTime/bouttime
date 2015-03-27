#!/bin/bash
set -e
export PATH=~/.gem/ruby/2.1.0/bin:$PATH
eval $(ssh-agent)
ssh-add
echo '--- bundling capistrano'
bundle install --gemfile=Gemfile.cap --path=~/.gem
echo '--- deploying'
cap $BUILDBOX_GITHUB_DEPLOYMENT_ENVIRONMENT $BUILDBOX_GITHUB_DEPLOYMENT_TASK
