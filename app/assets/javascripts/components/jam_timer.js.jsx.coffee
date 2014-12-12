cx = React.addons.classSet
exports = exports ? this
exports.JamTimer = React.createClass
  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    state =
      componentId: exports.wftda.functions.uniqueId()
      state: this.props.state
      jamNumber: this.props.jamNumber
      periodNumber: this.props.periodNumber
      jamClockAttributes:
        display: this.props.jamClock.display
        time: this.props.jamClock.time
        offset: this.props.jamClock.offset
      periodClockAttributes:
        display: this.props.periodClock.display
        time: this.props.periodClock.time
        offset: this.props.periodClock.offset
      homeAttributes:
        timeouts: this.props.home.timeouts
        hasOfficialReview: this.props.home.hasOfficialReview
        officialReviewsRetained: this.props.home.officialReviewsRetained
      awayAttributes:
        timeouts: this.props.away.timeouts
        hasOfficialReview: this.props.away.hasOfficialReview
        officialReviewsRetained: this.props.away.officialReviewsRetained
  buildOptions: (opts = {}) ->
    std_opts =
      role: 'Jam Timer'
      timestamp: Date.now() / 1000
      state: this.state
    $.extend(std_opts, opts)
  componentDidMount: () ->
    exports.wftda.ticks[this.state.id] = exports.wftda.ticks[this.state.id] || {}
    $dom = $(this.getDOMNode())
    #Send Events
    $dom.on 'click', '.start-jam-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_jam", this.buildOptions()
      this.startJam()
    $dom.on 'click', '.stop-jam-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.stop_jam", this.buildOptions()
    $dom.on 'click', '.start-lineup-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_lineup", this.buildOptions()
    $dom.on 'click', '.start-clock-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_clock", this.buildOptions()
    $dom.on 'click', '.stop-clock-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.stop_clock", this.buildOptions()
    $dom.on 'click', '.undo-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.undo", this.buildOptions()
    $dom.on 'click', '.timeout-section .timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.start_timeout", this.buildOptions()
    $dom.on 'click', '.official-timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_official_timeout", this.buildOptions()
    $dom.on 'click', '.home .timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_timeout", this.buildOptions()
    $dom.on 'click', '.home .review-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_review", this.buildOptions()
    $dom.on 'click', '.away .timeout-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_timeout", this.buildOptions()
    $dom.on 'click', '.away .review-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_review", this.buildOptions()
    $dom.on 'click', '.ended-by-time-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_time", this.buildOptions()
    $dom.on 'click', '.jam-called-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_calloff", this.buildOptions()
    # Receive Events
    dispatcher.bind 'heartbeat', this.handleHeartbeat
  handleHeartBeat: (msg) ->
    gameState = exports.wftda.functions.camelize(msg)
    console.log "Heartbeat"
  setUnofficialFinal: () ->
    this.state.inUnofficialFinal = true
    this.state.inOfficialFinal =  false
  setOfficialFinal: () ->
    this.state.inUnofficialFinal = false
    this.state.inOfficialFinal =  true
  receiveHeartbeat: (evt, data) ->
    this.state.lastHeartbeat = evt.timestamp
  startPeriodClock: () ->
    this.stopPeriodClock() #Clear to prevent lost interval function
    this.state.lastPeriodTick = Date.now() / 1000.0
    exports.wftda.ticks[this.state.id].periodTickFunction = setInterval(() =>
      this.tickperiodClock()
    ,exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  toggleJamClock: () ->
    if exports.wftda.ticks[this.state.id].jamTickFunction == null
      this.startJamClock()
    else
      this.stopJamClock()
  startJamClock: () ->
    this.stopJamClock() #Clear to prevent lost interval function
    this.state.lastJamTick = Date.now() / 1000.0
    exports.wftda.ticks[this.state.id].jamTickFunction = setInterval(() =>
      this.tickjamClock()
    ,exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  stopClocks: () ->
    this.stopJamClock()
    this.stopPeriodClock()
  isPeriodClockRunning: () ->
    exports.wftda.ticks[this.state.id].periodTickFunction != null
  isJamClockRunning: () ->
    exports.wftda.ticks[this.state.id].jamTickFunction != null
  stopJamClock: () ->
    clearInterval exports.wftda.ticks[this.state.id].jamTickFunction
    exports.wftda.ticks[this.state.id].jamTickFunction = null
  stopPeriodClock: () ->
    clearInterval exports.wftda.ticks[this.state.id].periodTickFunction
    exports.wftda.ticks[this.state.id].periodTickFunction = null
  tickperiodClock: () ->
    stopTime = Date.now() / 1000.0
    periodDelta = stopTime - this.state.lastPeriodTick
    this.state.lastPeriodTick = stopTime
    this.state.periodTime = this.state.periodTime - periodDelta
    this.state.periodTime = 0 if this.state.periodTime < 0
    this.state.periodClock = this.formatPeriodClock()
    dispatcher.trigger "jam_timer.period_tick", this.buildOptions
      clock: this.state.periodClock
  tickjamClock: () ->
    stopTime = Date.now() / 1000.0
    jamDelta = stopTime - this.state.lastJamTick
    this.state.lastJamTick = stopTime
    this.state.jamTime = this.state.jamTime - jamDelta
    this.state.jamTime = 0 if this.state.jamTime < 0
    this.state.jamClock = this.formatJamClock()
    dispatcher.trigger "jam_timer.jam_tick", this.buildOptions
      clock: this.state.jamClock
  clearJammers: () ->
    this.state.home.jammer = {}
    this.state.away.jammer = {}
  startJam: () ->
    this.clearTimeouts()
    this.clearJammers()
    this.state.jamTime = exports.wftda.constants.JAM_DURATION_IN_MS
    this.startJamClock()
    this.startPeriodClock()
    this.state.state = "jam"
    this.state.home.jamPoints = 0
    this.state.away.jamPoints = 0
    this.state.jamNumber =  this.state.jamNumber + 1
  stopJam: () ->
    this.stopClocks()
    this.startLineupClock()
  startLineupClock: () ->
    this.clearTimeouts()
    this.state.jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    this.state.state = "lineup"
  setTimeToDerby: (time = 60*60*1000) ->
    this.state.periodTime = 0
    this.state.state = "pregame"
    this.state.jamTime = time
  incrementHomeTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.home.points = this.state.home.points + score
    this.state.home.jamPoints = this.state.home.jamPoints + score
  decrementHomeTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.home.points = this.state.home.points - score
    this.state.home.jamPoints = this.state.home.jamPoints - score
  incrementAwayTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.away.points = this.state.away.points + score
    this.state.away.jamPoints = this.state.away.jamPoints + score
  decrementAwayTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.away.points = this.state.away.points - score
    this.state.away.jamPoints = this.state.away.jamPoints - score
  restoreHomeTeamOfficialReview: () ->
    this.state.home.hasOfficialReview = true
  restoreAwayTeamOfficialReview: () ->
    this.state.home.hasOfficialReview = true
  setHomeTeamName: (name) ->
    this.state.home.name = name
  setAwayTeamName: (name) ->
    this.state.away.name = name
  setHomeTeamJammer: (name) ->
    this.state.home.jammer.name = name
  setAwayTeamJammer: (name) ->
    this.state.away.jammer.name = name
  setHomeTeamLead: () ->
    this.state.home.jammer.lead = true
  setAwayTeamLead: () ->
    this.state.away.jammer.lead = true
  setHomeTeamNotLead: () ->
    this.state.home.jammer.lead = false
  setAwayTeamNotLead: () ->
    this.state.away.jammer.lead = false
  incrementPeriodNumber: (num = 1) ->
    this.state.periodNumber =  this.state.periodNumber + parseInt(num)
  decrementPeriodNumber: (num = 1) ->
    this.state.periodNumber =  this.state.periodNumber - parseInt(num)
  setPeriod: (num) ->
    this.state.periodNumber =  parseInt(num)
  incrementJamNumber: (num = 1) ->
    this.state.jamNumber =  this.state.jamNumber + parseInt(num)
  decrementJamNumber: (num = 1) ->
    this.state.jamNumber =  this.state.jamNumber - parseInt(num)
  setJamNumber: (num) ->
    this.state.jamNumber =  parseInt(num)
  startTimeout: () ->

    this.stopClocks()
    this.state.jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    this.state.state = "official_timeout"
  assignTimeoutToHomeTeam: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()

    this.state.state = "team_timeout"
    this.state.home.timeouts = this.state.home.timeouts - 1
    this.state.home.isTakingTimeout = true
    this.state.undoFunction = this.state.restoreHomeTeamTimeout
  restoreHomeTeamTimeout: () ->
    this.state.home.timeouts = this.state.home.timeouts + 1
    this.clearTimeouts()
  assignTimeoutToAwayTeam: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()

    this.state.state = "team_timeout"
    this.state.away.timeouts = this.state.away.timeouts - 1
    this.state.away.isTakingTimeout = true
    this.state.undoFunction = this.state.restoreAwayTeamTimeout
  restoreAwayTeamTimeout: () ->
    this.state.away.timeouts = this.state.away.timeouts + 1
    this.clearTimeouts()
  inTimeout: ()->
    this.state.state == "team_timeout" || "official_timeout"
  assignTimeoutToOfficials: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.jamTime = 0
    this.stopJamClock()
    this.state.state = "official_timeout"
    this.state.inOfficialTimeout = true

  assignTimeoutToHomeTeamOfficialReview: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.jamTime = 0
    this.startJamClock()

    this.state.home.hasOfficialReview = false
    this.state.home.isTakingOfficialReview = true
    this.state.state = "official_review"
    this.state.undoFunction = this.state.restoreHomeTeamOfficialReview
  restoreHomeTeamOfficialReview: (retained = false) ->
    this.state.home.hasOfficialReview = true
    this.clearTimeouts()
    if retained
      this.state.home.officialReviewsRetained = this.state.home.officialReviewsRetained + 1
  assignTimeoutToAwayTeamOfficialReview: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.jamTime = 0
    this.startJamClock()

    this.state.away.hasOfficialReview = false
    this.state.away.isTakingOfficialReview = true
    this.state.state = "official_review"
    this.state.undoFunction = this.state.restoreAwayTeamOfficialReview
  restoreAwayTeamOfficialReview: (retained = false) ->
    this.state.away.hasOfficialReview = true
    this.clearTimeouts()
    if retained
      this.state.away.officialReviewsRetained = this.state.away.officialReviewsRetained + 1
  incrementPeriodTime: (ms = 1000) ->
    this.state.periodTime = this.state.periodTime + ms
  decrementPeriodTime: (ms = 1000) ->
    this.state.periodTime = this.state.periodTime - ms
  clearAlerts: () ->
    this.clearTimeouts()
    this.state.inUnofficialFinal = false
    this.state.inOfficialFinal = false
    this.state.home.isUnofficialFinal = false
    this.state.home.isOfficialFinal = false
    this.state.away.isUnofficialFinal = false
    this.state.away.isOfficialFinal = false
  clearTimeouts: () ->
    this.state.home.isTakingTimeout = false
    this.state.away.isTakingTimeout = false
    this.state.home.isTakingOfficialReview = false
    this.state.away.isTakingOfficialReview = false

  formatJamClock: () ->
    exports.wftda.functions.toClock(this.state.jamTime, 2)
  formatPeriodClock: () ->
    exports.wftda.functions.toClock(this.state.periodTime, 2)
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
                <div className="period-clock">{this.state.periodClock.display}</div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{this.state.state}</strong>
                <div className="jam-clock">{this.state.jamClock.display}</div>
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