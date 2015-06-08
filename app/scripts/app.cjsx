$ = require 'jquery'
require 'bootstrap'
React = require 'react'
GamePicker = require './components/game_picker.cjsx'
React.render <GamePicker />, document.getElementById('react')