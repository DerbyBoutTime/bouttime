React = require 'react/addons'
TeamSelector = require './shared/team_selector.cjsx'
PenaltiesSummary = require './penalty_tracker/penalties_summary.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyWhiteBoard'
  render: () ->
    awayElement = <PenaltiesSummary team={@props.gameState.away}/>
    homeElement = <PenaltiesSummary team={@props.gameState.home}/>
    <div className="penalty-whiteboard">
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={@props.gameState.home}
        homeElement={homeElement} />
    </div>
