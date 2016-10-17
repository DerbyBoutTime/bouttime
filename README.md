[![CircleCI](https://circleci.com/gh/WFTDA/bouttime.svg?style=svg&circle-token=9b5d2312f6063d633b844c97c873653c13b26513)](https://circleci.com/gh/WFTDA/bouttime)
[![Code Climate](https://codeclimate.com/repos/55a800846956803db000be62/badges/e17304ef5725e2dbdf69/gpa.svg)](https://codeclimate.com/repos/55a800846956803db000be62/feed)

# Prerequisites

BoutTime requires version 0.10.x of [node.js](https://nodejs.org/) to run, which
can be installed from their website. Note this is an older version and we are
working on bringing the application up to date.

Alternatively, you may install node on OSX via [Homebrew](http://brew.sh/)

    $ brew install node010

# Installation

    $ npm install wftda-bouttime

# Update

To install the new version

    $ npm update wftda-bouttime

# Running a Server

    $ bouttime-server

# Development

Use `setup.sh` (i.e. `./setup.sh`) or follow the steps below to get your
development environment up and running:

    $ npm install -g bower gulp
    $ npm install
    $ npm link # Link from your globally installed node modules

`gulp watch` will automatically recompile assets when source files are changed

    $ gulp watch # Build and watch for changes with gulp

Start the server via `bouttime-server` or `nodemon bin/bouttime-server` to
listen for changes during development and navigate to `http://localhost:3000`.

## Publishing

Publish package to the private repository

    $ #Bump version numbers
    $ gulp package
    $ git commit -am "Version bump"
    $ git tag alpha.x.y.z #where alpha.x.y.z is the major,minor,version
    $ git push origin master --tags
    $ npm publish

