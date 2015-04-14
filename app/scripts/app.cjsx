require 'jquery'
require 'bootstrap'
React = require 'react'
Game = require './components/game.cjsx'
demoData = require './demo_data.coffee'
React.render <Game gameStateId=demoData.id />, document.getElementById('react')