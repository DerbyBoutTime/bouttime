#!/bin/bash

set -e -o pipefail

echo "installing bower and gulp globally"
npm install -g bower gulp

echo "installing NPM dependencies"
npm install

echo "installing bower dependencies"
bower install

echo "Dependencies have been installed."
echo "You can now run gulp to build the app and gulp watch to build as you make changes."
echo "Start the BoutTime server with ./bin/bouttime-server"
