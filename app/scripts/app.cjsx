require 'jquery'
require 'bootstrap'
React = require 'react'
Game = require './components/game.cjsx'
DemoData = require './demo_data.coffee'
gameStateId = DemoData.init()
React.render <Game gameStateId=gameStateId />, document.getElementById('react')