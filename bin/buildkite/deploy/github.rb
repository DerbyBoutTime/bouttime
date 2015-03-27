#!/usr/bin/env ruby
require "rubygems"
require "octokit"
begin
  branch = ENV["BUILDBOX_BRANCH"]
  client = Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"])
  environment = ENV["GITHUB_DEPLOYMENT_ENVIRONMENT"]
  repo = ENV["BUILDBOX_REPO"].split(":")[1].gsub(".git", "")
  puts "Attempting to create a GitHub Deployment for #{repo}##{branch} on #{environment}..."
  deployment = client.create_deployment(repo, branch,
                           { description: "Automagically deploying #{environment} from successful #{branch} build!",
                             environment: environment,
                             payload: { buildkite: true },
                             required_contexts: []
                           })
  puts "Deployment##{deployment["id"]} created."
rescue Octokit::Error => error
  puts error.message
  exit 1
end
