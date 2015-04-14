React = require 'react/addons'
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'
TeamSelector = require './shared/team_selector.cjsx'
TeamLineup = require './lineup_tracker/team_lineup.cjsx'
Jam = require '../models/jam.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupTracker'
  mixins: [CopyGameStateMixin]
  #React callbacks
  componentDidMount: () ->
    Jam.addChangeListener @onChange
  componentWillUnmount: () ->
    Jam.removeChangeListener @onChange
  render: () ->
    awayElement = <TeamLineup
      team={@state.gameState.away}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, @state.gameState.away)} />
    homeElement = <TeamLineup
      team={@state.gameState.home}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, @state.gameState.home)} />
    <div className="lineup-tracker">
      <TeamSelector
        away={@state.gameState.away}
        awayElement={awayElement}
        home={@state.gameState.home}
        homeElement={homeElement} />
    </div>
