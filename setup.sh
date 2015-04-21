#!/bin/bash
clear

echo "installing bower and gulp globally"
npm install -g bower gulp nodemon

echo "installing NPM dependencies"
npm install

echo "installing bower dependencies"
bower install

# echo "installing bower-installer"
# npm install -g bower-installer

# echo "moving local bower files to deploy directory"
# bower-installer

# echo "You should now be able to run 'gulp' to build and 'gulp run' to build and start the local server."
