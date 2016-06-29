[![CircleCI](https://circleci.com/gh/WFTDA/bouttime.svg?style=svg&circle-token=9b5d2312f6063d633b844c97c873653c13b26513)](https://circleci.com/gh/WFTDA/bouttime)

[![Code Climate](https://codeclimate.com/repos/559a0472e30ba07010002dbe/badges/9909fa76b2506419a836/gpa.svg)](https://codeclimate.com/repos/559a0472e30ba07010002dbe/feed)
[![Test Coverage](https://codeclimate.com/repos/559a0472e30ba07010002dbe/badges/9909fa76b2506419a836/coverage.svg)](https://codeclimate.com/repos/559a0472e30ba07010002dbe/coverage)

Prerequisites
===
BoutTime requires [node.js](https://nodejs.org/) to run, which can be installed from their website. Alternatively, you may install node on OSX via [Homebrew](http://brew.sh/)
```
$ brew install node
```

Installation
===
```
$ npm install -g wftda-bouttime
```

Running a Server
===
```
$ bouttime-server
```

Contribute
===
Install the unix startup script or follow the steps below

```
$ source setup.sh
```

```
$ npm install -g bower gulp nodemon
$ npm install
```

Link from your globally installed node modules

```
$ npm link
```

Build with gulp

```
$ gulp watch
```

will automatically recompile assets when source files are changed

Start the server via `bouttime-server` or `nodemon bin/bouttime-server` to listen for changes during development and navigate to `localhost:3000`

Publishing
===
Publish package to the private repository

```
$ #Bump version numbers
$ gulp package
$ git commit -am "Version bump"
$ git tag alpha.x.y.z #where alpha.x.y.z is the major,minor,version
$ git push origin master --tags
$ npm publish
```

To install the new version
```
$ npm update -g wftda-bouttime
```
