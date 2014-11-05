source 'https://rubygems.org'
ruby "2.1.4"

# Use Resque for background jobs
gem "resque", :require => "resque/server"
# Use Resque for scheduled jobs
gem 'resque-scheduler'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby
# Use airbrake to report errors
gem 'airbrake'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use unicorn as the app server
gem 'unicorn'
# Use Foreman to manager server starts/stop/restart
gem 'foreman'
# Make our logs prettier
gem 'colorize'
gem "lograge"
gem "scrolls"
gem "slim-rails"
gem "bootstrap-sass", "~> 3.3.0"
gem "autoprefixer-rails"


group :development do
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rails' #Still rails yo
  # Use Capistrano RBenv to manage the server ruby environment
  gem 'capistrano-rbenv'
  # Annotate your models and tests
  gem 'annotate'
  # Use Puppet for server configuration
  gem 'puppet'
  # Use Puppet Librian to manage puppet modules
  gem 'librarian-puppet'
  # Console debugging of errors in development
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request' # rails panel for chrome
  # Disappear all of the assets pipeline logging for dev
  gem 'quiet_assets'
end

group :development, :test do
  # Pry is better than normal debugging
  gem 'pry-rails'
  # Pry as a debugger
  gem 'pry-byebug'
  # adds ap command, handy for inspecting objects in test and console
  gem 'awesome_print'
  # Levenstein distance for incorrect method calls
  gem 'did_you_mean'
end

group :test do
  # Record and replay for API Tests
  # gem 'webmock'
  # gem 'vcr'
  gem 'rake'
  gem "minitest-rails"
end
