React = require 'react/addons'
TeamSelector = require './shared/team_selector'
TeamPenaltyTimers = require './penalty_box_timer/team_penalty_timers'
PeriodSummary = require './shared/period_summary'
JamSummary = require './shared/jam_summary'
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
      <div className="row gutters-xs hidden-xs hidden-sm">
        <div className="col-xs-6">
          <PeriodSummary
            period={@props.gameState.period}
            jamNumber={@props.gameState.jamNumber}
            clock={@props.gameState.periodClock} />
        </div>
        <div className="col-xs-6">
          <JamSummary
            state={@props.gameState.state}
            clock={@props.gameState.jamClock} />
        </div>
      </div>
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={home}
        homeElement={homeElement} />
    </div>
