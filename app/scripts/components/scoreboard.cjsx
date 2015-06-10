React = require 'react/addons'
$ = require 'jquery'
Jam = require '../models/jam.coffee'
ScoreboardClocks = require './scoreboard/scoreboard_clocks.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'Scoreboard'
  render: () ->
    awayJam = @props.gameState.getCurrentJam(@props.gameState.away)
    homeJam = @props.gameState.getCurrentJam(@props.gameState.home)
    homeJamPoints = awayJamPoints = 0
    if homeJam
      homeJamPoints = homeJam.getPoints()
    if awayJam
      awayJamPoints = awayJam.getPoints()
    periodNumber = switch @props.gameState.period
      when 'period 1' then '1'
      when 'period 2' then '2'
      when 'pregame' then 'Pre'
      when 'halftime' then 'Half'
      when 'unofficial final' then 'UF'
      when 'official final' then 'OF'
      else ''
    adsCS = cx
      'ads': true
      'hidden': $.inArray(@props.gameState.state, ["timeout"]) == -1
    flyinsCS = cx
      'fly-ins': true
      'hidden': $.inArray(@props.gameState.state, ["timeout"]) == -1
    neutralTimeoutCS = cx
      'scoreboard-alert': true
      'generic-timeout': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == null)
    officialTimeoutCS = cx
      'scoreboard-alert': true
      'official-timeout': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == "official_timeout")
    homeTeamTimeoutCS = cx
      'scoreboard-alert': true
      'home-team-timeout': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == "home_team_timeout")
    awayTeamTimeoutCS = cx
      'scoreboard-alert': true
      'away-team-timeout': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == "away_team_timeout")
    homeTeamOfficialReviewCS = cx
      'scoreboard-alert': true
      'home-team-official-review': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == "home_team_official_review")
    awayTeamOfficialReviewCS = cx
      'scoreboard-alert': true
      'away-team-official-review': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == "away_team_official_review")
    homeTeamUnofficialFinalCS = cx
      'scoreboard-alert': true
      'home-team-unofficial-final': true
      'hidden': true #!(@props.gameState.state == "timeout" && @props.gameState.timeout == "unofficial_final")
    awayTeamUnofficialFinalCS = cx
      'scoreboard-alert': true
      'away-team-unofficial-final': true
      'hidden': true #!(@props.gameState.state == "timeout" && @props.gameState.timeout == "unofficial_final")
    neutralUnofficialFinalCS = cx
      'scoreboard-alert': true
      'unofficial-final': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == "unofficial_final")
    homeTeamOfficialFinalCS = cx
      'scoreboard-alert': true
      'home-team-final': true
      'hidden': true #!(@props.gameState.state == "timeout" && @props.gameState.timeout == "official_final")
    awayTeamOfficialFinalCS = cx
      'scoreboard-alert': true
      'away-team-final': true
      'hidden': true ##!(@props.gameState.state == "timeout" && @props.gameState.timeout == "official_final")
    neutralOfficialFinalCS = cx
      'scoreboard-alert': true
      'official-final': true
      'hidden': !(@props.gameState.state == "timeout" && @props.gameState.timeout == "official_final")
    homeTeamOfficialReviewBarCS = cx
      'official-review': true
      'timeout-bar': true
      'active': @props.gameState.home.isTakingOfficialReview
      'inactive': @props.gameState.home.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.home.isTakingTimeout && @props.gameState.home.timeouts == 2
      'inactive': @props.gameState.home.timeouts < 3
    homeTeamTimeouts2CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.home.isTakingTimeout && @props.gameState.home.timeouts == 1
      'inactive': @props.gameState.home.timeouts < 2
    homeTeamTimeouts3CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.home.isTakingTimeout && @props.gameState.home.timeouts == 0
      'inactive': @props.gameState.home.timeouts < 1
    awayTeamOfficialReviewBarCS = cx
      'official-review': true
      'timeout-bar': true
      'active': @props.gameState.away.isTakingOfficialReview
      'inactive': @props.gameState.away.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.away.isTakingTimeout && @props.gameState.away.timeouts == 2
      'inactive': @props.gameState.away.timeouts < 3
    awayTeamTimeouts2CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.away.isTakingTimeout && @props.gameState.away.timeouts == 1
      'inactive': @props.gameState.away.timeouts < 2
    awayTeamTimeouts3CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.away.isTakingTimeout && @props.gameState.away.timeouts == 0
      'inactive': @props.gameState.away.timeouts < 1
    awayJammerLeadCS = cx
      'glyphicon': true
      'glyphicon-star': true
      'hidden': not awayJam? or not awayJam.passes[0]? or not awayJam.passes[0].lead or awayJam.passes.some (pass) -> pass.lostLead
    homeJammerLeadCS = cx
      'glyphicon': true
      'glyphicon-star': true
      'hidden': not homeJam? or not homeJam.passes[0]? or not homeJam.passes[0].lead or homeJam.passes.some (pass) -> pass.lostLead
    <div className="scoreboard" id="scoreboard">
      <section className="team home">
        <div className="logo">
          <img src={@props.gameState.home.logo} />
        </div>
        <div className="name">{@props.gameState.home.name}</div>
        <div className="color-bar" style={@props.gameState.home.colorBarStyle}></div>
        <div className="score">{@props.gameState.home.getPoints()}</div>
        <div className="jammer home-team-jammer">
          <div className="lead-status">
            <span className={homeJammerLeadCS}></span>
          </div>
          <div className="name">{if homeJam and homeJam.jammer then "#{homeJam.jammer.number} #{homeJam.jammer.name}"}</div>
        </div>
        <div className="timeouts home-team-timeouts">
          <div className={homeTeamOfficialReviewBarCS}></div>
          <div className={homeTeamTimeouts1CS}></div>
          <div className={homeTeamTimeouts2CS}></div>
          <div className={homeTeamTimeouts3CS}></div>
        </div>
      </section>
      <section className="clocks">
        <div className="clocks-border">
          <div className="period-jam-counts">
            <div className="period">
              <label className="hidden-xs">Period</label>
              <label className="visible-xs-block">Per</label>
              <div className="number period-number">{periodNumber}</div>
            </div>
            <div className="jam">
              <label>Jam</label>
              <div className="number jam-number">{@props.gameState.jamNumber}</div>
            </div>
          </div>
          <ScoreboardClocks
            ref="clocks"
            jamLabel={@props.gameState.state.replace(/_/g, ' ')}
            jamClock={@props.gameState.jamClock}
            periodClock={@props.gameState.periodClock}/>
        </div>
        <div className="jam-points-wrapper">
          <div className="home-team-jam-points points">{homeJamPoints}</div>
          <div className="away-team-jam-points points">{awayJamPoints}</div>
        </div>
      </section>
      <section className="team away">
        <div className="logo">
          <img src={@props.gameState.away.logo} />
        </div>
        <div className="name">{@props.gameState.away.name}</div>
        <div className="color-bar" style={@props.gameState.away.colorBarStyle}></div>
        <div className="score">{@props.gameState.away.getPoints()}</div>
        <div className="jammer away-team-jammer">
          <div className="lead-status">
            <span className={awayJammerLeadCS}></span>
          </div>
          <div className="name">{if awayJam and awayJam.jammer then "#{awayJam.jammer.number} #{awayJam.jammer.name}"}</div>
        </div>
        <div className="timeouts away-team-timeouts">
          <div className={awayTeamOfficialReviewBarCS}></div>
          <div className={awayTeamTimeouts1CS}></div>
          <div className={awayTeamTimeouts2CS}></div>
          <div className={awayTeamTimeouts3CS}></div>
        </div>
      </section>
      <section className="alerts">
        <div className="alert-home">
          <div className={homeTeamTimeoutCS}>timeout</div>
          <div className={homeTeamOfficialReviewCS}>official review</div>
          <div className={homeTeamUnofficialFinalCS}>unofficial final</div>
          <div className={homeTeamOfficialFinalCS}>final</div>
        </div>
        <div className="alert-away">
          <div className={awayTeamTimeoutCS}>timeout</div>
          <div className={awayTeamOfficialReviewCS}>official review</div>
          <div className={awayTeamUnofficialFinalCS}>unofficial final</div>
          <div className={awayTeamOfficialFinalCS}>final</div>
        </div>
        <div className="alert-neutral">
          <div className={neutralTimeoutCS}>timeout</div>
          <div className={officialTimeoutCS}>official timeout</div>
          <div className={neutralUnofficialFinalCS}>unofficial final</div>
          <div className={neutralOfficialFinalCS}>final</div>
        </div>
      </section>
      <section className={adsCS}></section>
      <section className={flyinsCS}></section>
    </div>
