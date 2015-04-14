React = require 'react/addons'
GameStateMixin = require '../mixins/game_state_mixin.cjsx'
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'
TeamSelector = require './shared/team_selector.cjsx'
TeamPenaltyTimers = require './penalty_box_timer/team_penalty_timers.cjsx'
GameClockSummary = require './penalty_box_timer/game_clock_summary.cjsx'
Team = require '../models/team.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyBoxTimer'
  mixins: [CopyGameStateMixin]
  componentDidMount: () ->
    Team.addChangeListener @onChange
  componentWillUnmount: () ->
    Team.removeChangeListener @onChange
  render: () ->
    home = @state.gameState.home
    away = @state.gameState.away
    homeElement = <TeamPenaltyTimers
      team={home}
      jamNumber={@state.gameState.jamNumber}
      setSelectorContext={@props.setSelectorContext.bind(null, home, @state.gameState.getCurrentJam(home))}/>
    awayElement = <TeamPenaltyTimers
      team={away}
      jamNumber={@state.gameState.jamNumber}
      setSelectorContext={@props.setSelectorContext.bind(null, away, @state.gameState.getCurrentJam(away))}/>
    <div className="penalty-box-timer">
      <GameClockSummary gameState={@state.gameState} />
      <TeamSelector
        away={@state.gameState.away}
        awayElement={awayElement}
        home={home}
        homeElement={homeElement} />
    </div>

