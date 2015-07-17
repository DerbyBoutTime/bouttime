React = require 'react/addons'
$ = require 'jquery'
Jam = require '../models/jam.coffee'
ScoreboardClocks = require './scoreboard/scoreboard_clocks'
ScoreboardTeam = require './scoreboard/scoreboard_team'
ScoreboardAlerts = require './scoreboard/scoreboard_alerts'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'Scoreboard'
  render: () ->
    awayJam = @props.gameState.getCurrentJam(@props.gameState.away)
    homeJam = @props.gameState.getCurrentJam(@props.gameState.home)
    <div className="scoreboard row" id="scoreboard">
      <div className="col-sm-4 col-xs-6 reversed">
        <ScoreboardTeam team={@props.gameState.home} jam={homeJam} />
      </div>
      <div className="col-sm-4 col-xs-12 first-xs">
        <ScoreboardClocks {...@props} />
        <div className="jam-points row gutters-xs hidden-xs">
          <div className="col-sm-6">
            <div className="points" style={@props.gameState.home.colorBarStyle}>{homeJam?.getPoints() ? 0}</div>
          </div>
          <div className="col-sm-6">
            <div className="points" style={@props.gameState.away.colorBarStyle}>{awayJam?.getPoints() ? 0}</div>              
          </div>
        </div>
      </div>
      <div className="col-sm-4 col-xs-6">
        <ScoreboardTeam team={@props.gameState.away} jam={awayJam}/>
      </div>
      <div className="col-xs-12">
        <ScoreboardAlerts {...@props} />
      </div>
    </div>
