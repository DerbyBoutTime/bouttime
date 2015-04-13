require 'jquery'
require 'bootstrap'
React = require 'react'
Game = require './components/game.cjsx'
demo_data = require './demo_data.coffee'

React.render <Game {...demo_data} />, document.getElementById('react')