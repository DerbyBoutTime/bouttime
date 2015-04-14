React = require 'react/addons'
TeamSelector = require './shared/team_selector.cjsx'
TeamPenaltyTimers = require './penalty_box_timer/team_penalty_timers.cjsx'
GameClockSummary = require './penalty_box_timer/game_clock_summary.cjsx'
Team = require '../models/team.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyBoxTimer'
  render: () ->
    home = @props.gameState.home
    away = @props.gameState.away
    homeElement = <TeamPenaltyTimers
      team={home}
      jamNumber={@props.gameState.jamNumber}
      setSelectorContext={@props.setSelectorContext.bind(null, home, @props.gameState.getCurrentJam(home))}/>
    awayElement = <TeamPenaltyTimers
      team={away}
      jamNumber={@props.gameState.jamNumber}
      setSelectorContext={@props.setSelectorContext.bind(null, away, @props.gameState.getCurrentJam(away))}/>
    <div className="penalty-box-timer">
      <GameClockSummary gameState={@props.gameState} />
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={home}
        homeElement={homeElement} />
    </div>

