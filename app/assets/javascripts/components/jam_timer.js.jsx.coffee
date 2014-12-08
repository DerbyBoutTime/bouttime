cx = React.addons.classSet
exports = exports ? this
exports.JamTimer = React.createClass
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    #CS = Class Set
    homeTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': this.state.home.isTakingOfficialReview
      'inactive': this.state.home.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'bar': true
      'active': this.state.home.isTakingTimeout && this.state.home.timeouts == 2
      'inactive': this.state.home.timeouts < 3
    homeTeamTimeouts2CS = cx
      'bar': true
      'active': this.state.home.isTakingTimeout && this.state.home.timeouts == 1
      'inactive': this.state.home.timeouts < 2
    homeTeamTimeouts3CS = cx
      'bar': true
      'active': this.state.home.isTakingTimeout && this.state.home.timeouts == 0
      'inactive': this.state.home.timeouts < 1
    awayTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': this.state.away.isTakingOfficialReview
      'inactive': this.state.away.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'bar': true
      'active': this.state.away.isTakingTimeout && this.state.away.timeouts == 2
      'inactive': this.state.away.timeouts < 3
    awayTeamTimeouts2CS = cx
      'bar': true
      'active': this.state.away.isTakingTimeout && this.state.away.timeouts == 1
      'inactive': this.state.away.timeouts < 2
    awayTeamTimeouts3CS = cx
      'bar': true
      'active': this.state.away.isTakingTimeout && this.state.away.timeouts == 0
      'inactive': this.state.away.timeouts < 1
    `<div id="jam-timer-view">
        <div className="row text-center">
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars away">
              <span className="jt-label">{this.state.home.initials}</span>
              <div className={homeTeamOfficialReviewCS}>0</div>
              <div className={homeTeamTimeouts1CS}></div>
              <div className={homeTeamTimeouts2CS}></div>
              <div className={homeTeamTimeouts3CS}></div>
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
                <div className="period-clock">{exports.wftda.functions.toClock(this.state.periodClock)}</div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{this.state.jamClockLabel}</strong>
                <div className="jam-clock">{exports.wftda.functions.toClock(this.state.jamClock)}</div>
              </div>
            </div>
          </div>
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars home">
              <span className="jt-label">{this.state.away.initials}</span>
              <div className={awayTeamOfficialReviewCS}>0</div>
              <div className={awayTeamTimeouts1CS}></div>
              <div className={awayTeamTimeouts2CS}></div>
              <div className={awayTeamTimeouts3CS}></div>
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
    </div>`