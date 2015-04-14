React = require 'react/addons'
functions = require '../functions.coffee'
TeamSelector = require './shared/team_selector.cjsx'
JamsList = require './scorekeeper/jams_list.cjsx'
Jam = require '../models/jam.coffee'
Pass = require '../models/pass.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'Scorekeeper'
  render: () ->
    awayElement = <JamsList
      jamNumber={@props.gameState.jamNumber}
      team={@props.gameState.away}
      setSelectorContext={@props.setSelectorContext.bind(null, @props.gameState.away)} />
    homeElement = <JamsList
      jamNumber={@props.gameState.jamNumber}
      team={@props.gameState.home}
      setSelectorContext={@props.setSelectorContext.bind(null, @props.gameState.home)} />
    <div className="scorekeeper">
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={@props.gameState.home}
        homeElement={homeElement} />
    </div>
