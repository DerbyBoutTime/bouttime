# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
cx = React.addons.classSet
exports = exports ? this
exports.Scoreboard = React.createClass
  render: () ->
    awayJam = @props.gameState.awayAttributes.jamStates[@props.gameState.jamNumber - 1] ? null
    homeJam = @props.gameState.homeAttributes.jamStates[@props.gameState.jamNumber - 1] ? null
    homeJamPoints = awayJamPoints = 0
    if homeJam
      homeJamPoints = homeJam.passStates.reduce ((sum, pass) -> sum += pass.points), 0
    if awayJam
      awayJamPoints = awayJam.passStates.reduce ((sum, pass) -> sum += pass.points), 0
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
      'active': @props.gameState.homeAttributes.isTakingOfficialReview
      'inactive': @props.gameState.homeAttributes.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.homeAttributes.isTakingTimeout && @props.gameState.homeAttributes.timeouts == 2
      'inactive': @props.gameState.homeAttributes.timeouts < 3
    homeTeamTimeouts2CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.homeAttributes.isTakingTimeout && @props.gameState.homeAttributes.timeouts == 1
      'inactive': @props.gameState.homeAttributes.timeouts < 2
    homeTeamTimeouts3CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.homeAttributes.isTakingTimeout && @props.gameState.homeAttributes.timeouts == 0
      'inactive': @props.gameState.homeAttributes.timeouts < 1
    awayTeamOfficialReviewBarCS = cx
      'official-review': true
      'timeout-bar': true
      'active': @props.gameState.awayAttributes.isTakingOfficialReview
      'inactive': @props.gameState.awayAttributes.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.awayAttributes.isTakingTimeout && @props.gameState.awayAttributes.timeouts == 2
      'inactive': @props.gameState.awayAttributes.timeouts < 3
    awayTeamTimeouts2CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.awayAttributes.isTakingTimeout && @props.gameState.awayAttributes.timeouts == 1
      'inactive': @props.gameState.awayAttributes.timeouts < 2
    awayTeamTimeouts3CS = cx
      'timeout-bar': true
      'timeout': true
      'active': @props.gameState.awayAttributes.isTakingTimeout && @props.gameState.awayAttributes.timeouts == 0
      'inactive': @props.gameState.awayAttributes.timeouts < 1
    awayJammerLeadCS = cx
      'glyphicon': true
      'glyphicon-star': true
      'hidden': not awayJam? or not awayJam.passStates[0]? or not awayJam.passStates[0].lead or awayJam.passStates.some (pass) -> pass.lostLead?
    homeJammerLeadCS = cx
      'glyphicon': true
      'glyphicon-star': true
      'hidden': not homeJam? or not homeJam.passStates[0]? or not homeJam.passStates[0].lead or homeJam.passStates.some (pass) -> pass.lostLead?
    <div className="scoreboard" id="scoreboard">
      <section className="team home">
        <div className="logo">
          <img src={@props.gameState.homeAttributes.logo} />
        </div>
        <div className="name">{@props.gameState.homeAttributes.name}</div>
        <div className="color-bar" style={@props.gameState.homeAttributes.colorBarStyle}></div>
        <div className="score">{@props.gameState.homeAttributes.points}</div>
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
              <div className="number period-number">{@props.gameState.periodNumber}</div>
            </div>
            <div className="jam">
              <label>Jam</label>
              <div className="number jam-number">{@props.gameState.jamNumber}</div>
            </div>
          </div>
          <div className="period-clock">
            <label className="visible-xs-block">Game</label>
            <div className="clock period-clock">{@props.gameState.periodClockAttributes.display}</div>
          </div>
          <div className="jam-clock">
            <label className="jam-clock-label">{@props.gameState.state}</label>
            <div className="clock">{@props.gameState.jamClockAttributes.display}</div>
          </div>
        </div>
        <div className="jam-points-wrapper">
          <div className="home-team-jam-points points">{homeJamPoints}</div>
          <div className="away-team-jam-points points">{awayJamPoints}</div>
        </div>
      </section>
      <section className="team away">
        <div className="logo">
          <img src={@props.gameState.awayAttributes.logo} />
        </div>
        <div className="name">{@props.gameState.awayAttributes.name}</div>
        <div className="color-bar" style={@props.gameState.awayAttributes.colorBarStyle}></div>
        <div className="score">{@props.gameState.awayAttributes.points}</div>
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
