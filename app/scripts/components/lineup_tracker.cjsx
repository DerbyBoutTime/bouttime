React = require 'react/addons'
TeamSelector = require './shared/team_selector'
TeamLineup = require './lineup_tracker/team_lineup'
LineupSelector = require './lineup_tracker/lineup_selector'
Jam = require '../models/jam.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupTracker'
  getInitialState: () ->
    lineupSelectorContext:
      team: null
      jam: null
      selectHandler: null
  setSelectorContext: (team, jam, selectHandler) ->
    @setState
      lineupSelectorContext:
        team: team
        jam: jam
        selectHandler: selectHandler
  #React callbacks
  render: () ->
    awayElement = <TeamLineup
      team={@props.gameState.away}
      setSelectorContextHandler={@setSelectorContext.bind(null, @props.gameState.away)} />
    homeElement = <TeamLineup
      team={@props.gameState.home}
      setSelectorContextHandler={@setSelectorContext.bind(null, @props.gameState.home)} />
    <div className="lineup-tracker">
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={@props.gameState.home}
        homeElement={homeElement} />
      <LineupSelector {...@state.lineupSelectorContext} />
    </div>

