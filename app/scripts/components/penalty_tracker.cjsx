React = require 'react/addons'
functions = require '../functions.coffee'
GameStateMixin = require '../mixins/game_state_mixin.cjsx'
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'
TeamSelector = require './shared/team_selector.cjsx'
TeamPenalties = require './penalty_tracker/team_penalties.cjsx'
Skater = require '../models/skater.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyTracker'
  mixins: [CopyGameStateMixin]
  componentDidMount: () ->
    Skater.addChangeListener @onChange
  componentWillUnmount: () ->
    Skater.removeChangeListener @onChange
  render: () ->
    awayElement = <TeamPenalties gameState={@state.gameState} team={@state.gameState.away}/>
    homeElement = <TeamPenalties gameState={@state.gameState} team={@state.gameState.home}/>
    <div className="penalty-tracker">
      <TeamSelector
        away={@state.gameState.away}
        awayElement={awayElement}
        home={@state.gameState.home}
        homeElement={homeElement} />
   	</div>
