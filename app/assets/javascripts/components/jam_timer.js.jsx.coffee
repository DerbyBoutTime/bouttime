cx = React.addons.classSet
exports = exports ? this
exports.JamTimer = React.createClass
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Jam Timer'
    $(std_opts).extend(opts)
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
    $dom.on 'click', '.start-jam-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_jam", this.getStandardOptions()
    $dom.on 'click', '.stop-jam-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.stop_jam", this.getStandardOptions()
    $dom.on 'click', '.start-lineup-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_lineup", this.getStandardOptions()
    $dom.on 'click', '.start-clock-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_clock", this.getStandardOptions()
    $dom.on 'click', '.stop-clock-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.stop_clock", this.getStandardOptions()
    $dom.on 'click', '.undo-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.undo", this.getStandardOptions()
    $dom.on 'click', '.timeout-section .timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_timeout", this.getStandardOptions()
    $dom.on 'click', '.official-timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_official_timeout", this.getStandardOptions()
    $dom.on 'click', '.home .timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_timeout", this.getStandardOptions()
    $dom.on 'click', '.home .review-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_review", this.getStandardOptions()
    $dom.on 'click', '.away .timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_timeout", this.getStandardOptions()
    $dom.on 'click', '.away .review-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_review", this.getStandardOptions()
    $dom.on 'click', '.ended-by-time-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_time", this.getStandardOptions()
    $dom.on 'click', '.jam-called-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_calloff", this.getStandardOptions()
    # $dom.on 'click', '', null, (evt) =>
    #   exports.dispatcher.trigger "jam_timer.stuff",
    #     time: new Date()
    #     role: 'Jam Timer'
    # setInterval( () ->
    #   exports.dispatcher.trigger "client_heartbeat",
    #     time: new Date()
    #     role: 'Jam Timer'
    # ,3000)
  render: () ->
    #CS = Class Set
    timeoutSectionCS = cx
      'timeout-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["jam", "lineup", "team_timeout", "official_timeout", "official_review", "unofficial_final"]) == -1
    timeoutExplanationSectionCS = cx
      'timeout-explanation-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["team_timeout", "official_timeout", "official_review"]) == -1
    undoSectionCS = cx
      'undo-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["jam", "lineup", "team_timeout", "official_timeout", "official_review", "unofficial_final", "final"]) == -1
    startClockSectionCS = cx
      'start-clock-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["pregame", "halftime", "final"]) == -1
    stopClockSectionCS = cx
      'stop-clock-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["pregame"]) == -1
    startJamSectionCS = cx
      'start-jam-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["pregame", "halftime", "lineup"]) == -1
    stopJamSectionCS = cx
      'stop-jam-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["jam"]) == -1
    startLineupSectionCS = cx
      'start-lineup-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["pregame", "halftime",  "team_timeout", "official_timeout", "official_review", "unofficial_final", "final"]) == -1
    jamExplanationSectionCS = cx
      'jam-explanation-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["lineup", "team_timeout", "official_timeout", "official_review", "unofficial_final"]) == -1
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
    `<div className="jam-timer">
        <div className="row text-center">
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars home">
              <span className="jt-label">{this.state.home.initials}</span>
              <div className={homeTeamOfficialReviewCS}>0</div>
              <div className={homeTeamTimeouts1CS}></div>
              <div className={homeTeamTimeouts2CS}></div>
              <div className={homeTeamTimeouts3CS}></div>
            </div>
          </div>
          <div className="col-md-8 col-xs-8">
            <div className="row">
              <div className="col-xs-12">
                <strong>
                  <span className="jt-label pull-left">
                    Period {this.state.periodNumber}
                  </span>
                  <span className="jt-label pull-right">
                    Jam {this.state.jamNumber}
                  </span>
                </strong>
              </div>
              <div className="col-md-12 col-xs-12">
                <div className="period-clock">
                  {exports.wftda.functions.toClock(this.state.periodClock,2,false,true)}
                </div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{this.state.jamClockLabel}</strong>
                <div className="jam-clock">
                  {exports.wftda.functions.toClock(this.state.jamClock,2,false,false)}
                </div>
              </div>
            </div>
          </div>
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars away">
              <span className="jt-label">{this.state.away.initials}</span>
              <div className={awayTeamOfficialReviewCS}>0</div>
              <div className={awayTeamTimeouts1CS}></div>
              <div className={awayTeamTimeouts2CS}></div>
              <div className={awayTeamTimeouts3CS}></div>
            </div>
          </div>
        </div>
        <div className={timeoutSectionCS}>
          <div className="col-xs-12">
            <button className="btn btn-block timeout-btn">TIMEOUT</button>
          </div>
        </div>
        <div className={timeoutExplanationSectionCS}>
          <div className="col-xs-4">
            <div className="home">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="btn btn-block timeout-btn">TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-top-05">
                <div className="col-md-12 col-xs-12">
                  <button className="btn btn-block review-btn">
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="col-md-4 col-xs-4">
            <button className="btn btn-lg btn-block official-timeout-btn">
              <div>OFFICIAL</div>
              <div>TIMEOUT</div>
            </button>
          </div>
          <div className="col-md-4 col-xs-4 timeouts">
            <div className="away">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="btn btn-block timeout-btn">TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-top-05">
                <div className="col-md-12 col-xs-12">
                  <button className="btn btn-block review-btn">
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className={undoSectionCS}>
          <div className="col-xs-12">
            <button className="btn btn-lg btn-block undo-btn">UNDO</button>
          </div>
        </div>
        <div className={startClockSectionCS}>
          <div className="col-xs-12">
            <button className="btn btn-lg btn-block start-clock-btn">START CLOCK</button>
          </div>
        </div>
        <div className={stopClockSectionCS}>
          <div className="col-xs-12">
            <button className="btn btn-lg btn-block stop-clock-btn">STOP CLOCK</button>
          </div>
        </div>
        <div className={startJamSectionCS}>
          <div className="col-xs-12">
            <button className="btn btn-lg btn-block start-jam-btn">START JAM</button>
          </div>
        </div>
        <div className={stopJamSectionCS}>
          <div className="col-xs-12">
            <button className="btn btn-lg btn-block stop-jam-btn">STOP JAM</button>
          </div>
        </div>
        <div className={startLineupSectionCS}>
          <div className="col-xs-12 start-lineup-section">
            <button className="btn btn-lg btn-block start-lineup-btn">START LINEUP</button>
          </div>
        </div>
        <div className={jamExplanationSectionCS}>
          <div className="col-xs-6">
            <button className="btn btn-lg btn-block jam-called-btn">
              JAM CALLED
            </button>
          </div>
          <div className="col-xs-6">
            <button className="btn btn-lg btn-block ended-by-time-btn">
              ENDED BY TIME
            </button>
          </div>
        </div>
    </div>`