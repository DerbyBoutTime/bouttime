React = require 'react/addons'
functions = require '../functions.coffee'
TeamSelector = require './shared/team_selector.cjsx'
TeamPenalties = require './penalty_tracker/team_penalties.cjsx'
Skater = require '../models/skater.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyTracker'
  render: () ->
    awayElement = <TeamPenalties gameState={@props.gameState} team={@props.gameState.away}/>
    homeElement = <TeamPenalties gameState={@props.gameState} team={@props.gameState.home}/>
    <div className="penalty-tracker">
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={@props.gameState.home}
        homeElement={homeElement} />
   	</div>
