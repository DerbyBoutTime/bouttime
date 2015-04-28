Setup Guide for Contributors
===
Install the unix startup script or follow the steps below

```
$ source setup.sh
```

```
$ npm install -g bower gulp nodemon
$ npm install
$ bower install
```

Link from your globally installed node modules

```
npm link
```

Start the server via `bouttime-server` or `nodemon bin/bouttime-server` to listen for changes during development and navigate to `localhost:3000`