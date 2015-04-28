React = require 'react/addons'
TeamSelector = require './shared/team_selector.cjsx'
TeamLineup = require './lineup_tracker/team_lineup.cjsx'
Jam = require '../models/jam.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupTracker'
  #React callbacks
  render: () ->
    awayElement = <TeamLineup
      team={@props.gameState.away}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, @props.gameState.away)} />
    homeElement = <TeamLineup
      team={@props.gameState.home}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, @props.gameState.home)} />
    <div className="lineup-tracker">
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={@props.gameState.home}
        homeElement={homeElement} />
    </div>
