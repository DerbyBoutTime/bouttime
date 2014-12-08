cx = React.addons.classSet
exports = exports ? this
exports.JamTimer = React.createClass
  getInitialState: () ->
    jamNumber: this.props.jamNumber
    periodNumber: this.props.periodNumber
    jamClockLabel: this.props.jamClockLabel
    jamClock: this.props.jamClock
    periodClock: this.props.periodClock
    teams: this.props.teams
  render: () ->
    #CS = Class Set
    homeTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': this.state.teams.home.isTakingOfficialReview
      'inactive': this.state.teams.home.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'bar': true
      'active': this.state.teams.home.isTakingTimeout && this.state.teams.home.timeouts == 2
      'inactive': this.state.teams.home.timeouts < 3
    homeTeamTimeouts2CS = cx
      'bar': true
      'active': this.state.teams.home.isTakingTimeout && this.state.teams.home.timeouts == 1
      'inactive': this.state.teams.home.timeouts < 2
    homeTeamTimeouts3CS = cx
      'bar': true
      'active': this.state.teams.home.isTakingTimeout && this.state.teams.home.timeouts == 0
      'inactive': this.state.teams.home.timeouts < 1
    awayTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': this.state.teams.away.isTakingOfficialReview
      'inactive': this.state.teams.away.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'bar': true
      'active': this.state.teams.away.isTakingTimeout && this.state.teams.away.timeouts == 2
      'inactive': this.state.teams.away.timeouts < 3
    awayTeamTimeouts2CS = cx
      'bar': true
      'active': this.state.teams.away.isTakingTimeout && this.state.teams.away.timeouts == 1
      'inactive': this.state.teams.away.timeouts < 2
    awayTeamTimeouts3CS = cx
      'bar': true
      'active': this.state.teams.away.isTakingTimeout && this.state.teams.away.timeouts == 0
      'inactive': this.state.teams.away.timeouts < 1
    `<div id="jam-timer-view">
      <div className="row text-center">
        <div className="col-md-2 col-xs-2">
          <div className="timeout-bars away">
            <span className="jt-label">{this.state.teams.home.initials}</span>
            <div className={homeTeamOfficialReviewCS}>0</div>
            <div className={homeTeamTimeouts1CS}/>
            <div className={homeTeamTimeouts2CS}/>
            <div className={homeTeamTimeouts3CS}/>
        </div>
      </div>
      <div className="col-md-8 col-xs-8">
        <div className="row">
          <div className="col-md-8 col-xs-8 col-md-offset-2 col-xs-offset-2">
            <strong>
              <span className="jt-label pull-left">Period {this.state.periodNumber}</span>
              <span className="jt-label pull-right">Jam {this.state.jamNumber}</span>
            </strong>
          </div>
          <div className="col-md-12 col-xs-12">
            <div className="period-clock">{this.state.periodClock}</div>
          </div>
          <div className="col-md-12 col-xs-12">
            <strong className="jt-label">{this.state.jamClockLabel}</strong>
            <div className="jam-clock">{this.state.jamClock}
          </div>
        </div>
      </div>
    </div>
    <div className="col-md-2 col-xs-2">
      <div className="timeout-bars home">
        <span className="jt-label">{this.state.teams.away.initials}</span>
        <div className={awayTeamOfficialReviewCS}>0</div>
        <div className={awayTeamTimeouts1CS}/>
        <div className={awayTeamTimeouts2CS}/>
        <div className={awayTeamTimeouts3CS}/>
      </div>
    </div>
    </div>
    <div className="text-center row">
      <div className="col-md-4 col-xs-4">
        <div className="away">
          <div className="row">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">TIMEOUT</button>
            </div>
          </div>
          <div className="row margin-top-05">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">OFF. REVIEW</button>
            </div>
          </div>
        </div>
      </div>
      <div className="col-md-4 col-xs-4">
        <div className="official-timeout">OFFICIAL TIMEOUT</div>
      </div>
      <div className="col-md-4 col-xs-4">
        <div className="home">
          <div className="row">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">TIMEOUT</button>
            </div>
          </div>
          <div className="row margin-top-05">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">OFF. REVIEW</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div className="row margin-top-05">
      <div className="col-md-6 col-xs-6">
        <button className="btn btn-lg btn-block">STOP CLOCK</button>
      </div>
      <div className="col-md-6 col-xs-6">
        <button className="btn btn-lg btn-block">UNDO</button>
      </div>
    </div>
    <div className="row margin-top-05">
      <div className="col-md-12 col-xs-12">
        <button className="btn-start-jam">START JAM</button>
      </div>
    </div>
    </div>
`