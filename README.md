Prerequisites
===
BoutTime requires [node.js](https://nodejs.org/) to run, which can be installed from their website. Alternatively, you may install node on OSX via [Homebrew](http://brew.sh/)
```
$ brew install node
```

Installation
===
```
$ npm install -g @wftda/bouttime
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
Node private module is at https://www.npmjs.com/package/@wftda/bouttime

```
$ gulp package
$ git tag x.y.z #where x.y.z is the major,minor,version
$ git push origin master --tags
$ npm publish --tag x.y.z --access restricted
```
