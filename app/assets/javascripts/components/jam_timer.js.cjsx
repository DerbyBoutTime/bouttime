cx = React.addons.classSet
exports = exports ? this
exports.JamTimer = React.createClass
  displayName: 'JamTimer'
  getInitialState: () ->
    state =
      id: this.props.gameState.id
      componentId: exports.wftda.functions.uniqueId()
      state: this.props.gameState.state
      jamNumber: this.props.gameState.jamNumber
      periodNumber: this.props.gameState.periodNumber
      jamClockAttributes: this.props.gameState.jamClockAttributes
        # display: this.props.gameState.jamClockAttributes.display
        # time: this.props.gameState.jamClockAttributes.time
        # tick: this.props.gameState.jamClockAttributes.tick
      periodClockAttributes: this.props.gameState.periodClockAttributes
        # display: this.props.gameState.periodClockAttributes.display
        # time: this.props.gameState.periodClockAttributes.time
        # tick: this.props.gameState.periodClockAttributes.tick
      homeAttributes: this.props.gameState.homeAttributes
        # timeouts: this.props.gameState.homeAttributes.timeouts
        # hasOfficialReview: this.props.gameState.homeAttributes.hasOfficialReview
        # officialReviewsRetained: this.props.gameState.homeAttributes.officialReviewsRetained
      awayAttributes: this.props.gameState.awayAttributes
        # timeouts: this.props.gameState.awayAttributes.timeouts
        # hasOfficialReview: this.props.gameState.awayAttributes.hasOfficialReview
        # officialReviewsRetained: this.props.gameState.awayAttributes.officialReviewsRetained
  componentWillReceiveProps: (nextProps) ->

  buildOptions: (opts = {}) ->
    std_opts =
      role: 'Jam Timer'
      timestamp: Date.now()
      state: this.state
    $.extend(std_opts, opts)
  componentDidMount: () ->
    exports.wftda.ticks[this.state.id] = exports.wftda.ticks[this.state.id] || {}
    $dom = $(this.getDOMNode())
    #Send Events
    $dom.on 'click', '.start-jam-btn', null, (evt) =>
      this.startJam()
      exports.dispatcher.trigger "jam_timer.start_jam", this.buildOptions()
      console.log("start jam")
    $dom.on 'click', '.stop-jam-btn', null, (evt) =>
      this.stopJam()
      exports.dispatcher.trigger "jam_timer.stop_jam", this.buildOptions()
      console.log("stop jam")
    $dom.on 'click', '.start-lineup-btn', null, (evt) =>
      this.startLineupClock()
      exports.dispatcher.trigger "jam_timer.start_lineup", this.buildOptions()
      console.log("start lineup")
    $dom.on 'click', '.start-clock-btn', null, (evt) =>
      this.startJamClock()
      exports.dispatcher.trigger "jam_timer.start_clock", this.buildOptions()
      console.log("start clock")
    $dom.on 'click', '.stop-clock-btn', null, (evt) =>
      this.stopJamClock()
      exports.dispatcher.trigger "jam_timer.stop_clock", this.buildOptions()
      console.log("stop clock")
    $dom.on 'click', '.undo-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.undo", this.buildOptions()
      console.log("undo")
    $dom.on 'click', '.timeout-section .timeout-btn', null, (evt) =>
      this.startTimeout()
      exports.dispatcher.trigger "jam_timer.start_timeout", this.buildOptions()
      console.log("start timeout")
    $dom.on 'click', '.official-timeout-btn', null, (evt) =>
      this.markAsOfficialTimeout()
      exports.dispatcher.trigger "jam_timer.mark_as_official_timeout", this.buildOptions()
      console.log("mark as official timeout")
    $dom.on 'click', '.home .timeout-btn', null, (evt) =>
      this.markAsHomeTeamTimeout()
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_timeout", this.buildOptions()
      console.log("mark as home team timeout")
    $dom.on 'click', '.home .review-btn', null, (evt) =>
      this.markAsHomeTeamOfficialReview()
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_review", this.buildOptions()
      console.log("mark as home team official review")
    $dom.on 'click', '.away .timeout-btn', null, (evt) =>
      this.markAsAwayTeamTimeout()
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_timeout", this.buildOptions()
      console.log("mark as away team timeout")
    $dom.on 'click', '.away .review-btn', null, (evt) =>
      this.markAsAwayTeamOfficialReview()
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_review", this.buildOptions()
      console.log("mark as away team official review")
    $dom.on 'click', '.ended-by-time-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_time", this.buildOptions()
      console.log("mark as ended by time")
    $dom.on 'click', '.jam-called-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_calloff", this.buildOptions()
      console.log("mark as ended by calloff")
    # Receive Events
    dispatcher.bind 'heartbeat', this.handleHeartbeat
  componentWillUnmount: () ->
    this.stopClocks()
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
    this.state.periodClockAttributes.tick = Date.now()
    exports.wftda.ticks[this.state.id].periodTickFunction = setInterval(() =>
      this.tickPeriodClock()
    ,exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  toggleJamClock: () ->
    if exports.wftda.ticks[this.state.id].jamTickFunction == null
      this.startJamClock()
    else
      this.stopJamClock()
  startJamClock: () ->
    this.stopJamClock() #Clear to prevent lost interval function
    this.state.jamClockAttributes.tick = Date.now()
    exports.wftda.ticks[this.state.id].jamTickFunction = setInterval(() =>
      this.tickJamClock()
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
  tickPeriodClock: () ->
    #console.log("tick period clock")
    stopTick = Date.now()
    periodDelta = stopTick - this.state.periodClockAttributes.tick
    this.state.periodClockAttributes.tick = stopTick
    this.state.periodClockAttributes.time = this.state.periodClockAttributes.time - periodDelta
    this.state.periodClockAttributes.time = 0 if this.state.periodClockAttributes.time < 0
    this.state.periodClockAttributes.display = this.formatPeriodClock()
    @setState(@state)
    # dispatcher.trigger "jam_timer.period_tick", this.buildOptions
    #   state:
    #     periodClockAttributes: this.state.periodClockAttributes
  tickJamClock: () ->
    #console.log("tick jam clock")
    stopTick = Date.now()
    jamDelta = stopTick - this.state.jamClockAttributes.tick
    this.state.jamClockAttributes.tick = stopTick
    this.state.jamClockAttributes.time = this.state.jamClockAttributes.time - jamDelta
    this.state.jamClockAttributes.time = 0 if this.state.jamClockAttributes.time < 0
    this.state.jamClockAttributes.display = this.formatJamClock()
    @setState(@state)
    # dispatcher.trigger "jam_timer.jam_tick", this.buildOptions
    #   state:
    #     id: this.state.id
    #     jamClockAttributes: this.state.jamClockAttributes
  clearJammers: () ->
    this.state.homeAttributes.jammer = {}
    this.state.awayAttributes.jammer = {}
  startJam: () ->
    this.clearTimeouts()
    this.clearJammers()
    this.state.jamClockAttributes.time = exports.wftda.constants.JAM_DURATION_IN_MS
    this.startJamClock()
    this.startPeriodClock()
    this.state.state = "jam"
    this.state.homeAttributes.jamPoints = 0
    this.state.awayAttributes.jamPoints = 0
    if this.state.periodClockAttributes.time == 0
      this.state.periodNumber = this.state.periodNumber + 1
      this.state.periodClockAttributes.time = exports.wftda.constants.PERIOD_DURATION_IN_MS
    this.state.jamNumber = this.state.jamNumber + 1
    for i in [@state.awayAttributes.jamStates.length+1 .. @state.jamNumber] by 1
      @state.awayAttributes.jamStates.push jamNumber: i
    for i in [@state.homeAttributes.jamStates.length+1 .. @state.jamNumber] by 1
      @state.homeAttributes.jamStates.push jamNumber: i

  stopJam: () ->
    this.stopClocks()
    this.startLineupClock()
  startLineupClock: () ->
    this.clearTimeouts()
    this.state.jamClockAttributes.time = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.state.homeAttributes.jammerAttributes = {id: this.state.homeAttributes.jammerAttributes.id}
    this.state.awayAttributes.jammerAttributes = {id: this.state.awayAttributes.jammerAttributes.id}
    this.startJamClock()
    this.state.state = "lineup"
  setTimeToDerby: (time = 60*60*1000) ->
    this.state.periodClockAttributes.time = 0
    this.state.state = "pregame"
    this.state.jamClockAttributes.time = time
  incrementHomeTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.homeAttributes.points = this.state.homeAttributes.points + score
    this.state.homeAttributes.jamPoints = this.state.homeAttributes.jamPoints + score
  decrementHomeTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.homeAttributes.points = this.state.homeAttributes.points - score
    this.state.homeAttributes.jamPoints = this.state.homeAttributes.jamPoints - score
  incrementAwayTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.awayAttributes.points = this.state.awayAttributes.points + score
    this.state.awayAttributes.jamPoints = this.state.awayAttributes.jamPoints + score
  decrementAwayTeamScore: (score = 1) ->
    score = parseInt(score)
    this.state.awayAttributes.points = this.state.awayAttributes.points - score
    this.state.awayAttributes.jamPoints = this.state.awayAttributes.jamPoints - score
  restoreHomeTeamOfficialReview: () ->
    this.state.homeAttributes.hasOfficialReview = true
  restoreAwayTeamOfficialReview: () ->
    this.state.homeAttributes.hasOfficialReview = true
  setHomeTeamName: (name) ->
    this.state.homeAttributes.name = name
  setAwayTeamName: (name) ->
    this.state.awayAttributes.name = name
  setHomeTeamJammer: (name) ->
    this.state.homeAttributes.jammerAttributes.name = name
  setAwayTeamJammer: (name) ->
    this.state.awayAttributes.jammerAttributes.name = name
  setHomeTeamLead: () ->
    this.state.homeAttributes.jammerAttributes.lead = true
  setAwayTeamLead: () ->
    this.state.awayAttributes.jammerAttributes.lead = true
  setHomeTeamNotLead: () ->
    this.state.homeAttributes.jammerAttributes.lead = false
  setAwayTeamNotLead: () ->
    this.state.awayAttributes.jammerAttributes.lead = false
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
    this.state.jamClockAttributes.time = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    this.state.state = "timeout"
    this.state.timeout = null
  markAsHomeTeamTimeout: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.state = "timeout"
    this.state.timeout = "home_team_timeout"
    this.state.homeAttributes.timeouts = this.state.homeAttributes.timeouts - 1
    this.state.homeAttributes.isTakingTimeout = true
    this.state.undoFunction = this.state.restoreHomeTeamTimeout
    this.forceUpdate()
  restoreHomeTeamTimeout: () ->
    this.state.homeAttributes.timeouts = this.state.homeAttributes.timeouts + 1
    this.clearTimeouts()
  markAsAwayTeamTimeout: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.state = "timeout"
    this.state.timeout = "away_team_timeout"
    this.state.awayAttributes.timeouts = this.state.awayAttributes.timeouts - 1
    this.state.awayAttributes.isTakingTimeout = true
    this.state.undoFunction = this.state.restoreAwayTeamTimeout
    this.forceUpdate()
  restoreAwayTeamTimeout: () ->
    this.state.awayAttributes.timeouts = this.state.awayAttributes.timeouts + 1
    this.clearTimeouts()
  inTimeout: ()->
    this.state.state == "team_timeout" || "official_timeout"
  markAsOfficialTimeout: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.jamClockAttributes.time = 0
    this.state.jamClockAttributes.display = this.formatJamClock()
    this.stopJamClock()
    this.state.state = "timeout"
    this.state.timeout = "official_timeout"
    this.state.inOfficialTimeout = true
    this.forceUpdate()
  markAsHomeTeamOfficialReview: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.jamClockAttributes.time = 0
    this.startJamClock()
    this.state.homeAttributes.hasOfficialReview = false
    this.state.homeAttributes.isTakingOfficialReview = true
    this.state.state = "timeout"
    this.state.timeout = "home_team_official_review"
    this.state.undoFunction = this.state.restoreHomeTeamOfficialReview
    this.forceUpdate()
  restoreHomeTeamOfficialReview: (retained = false) ->
    this.state.homeAttributes.hasOfficialReview = true
    this.clearTimeouts()
    if retained
      this.state.homeAttributes.officialReviewsRetained = this.state.homeAttributes.officialReviewsRetained + 1
  markAsAwayTeamOfficialReview: () ->
    if this.inTimeout() == false
      this.startTimeout()
    this.clearTimeouts()
    this.state.jamClockAttributes.time = 0
    this.startJamClock()
    this.state.awayAttributes.hasOfficialReview = false
    this.state.awayAttributes.isTakingOfficialReview = true
    this.state.state = "timeout"
    this.state.timeout = "away_team_official_review"
    this.state.undoFunction = this.state.restoreAwayTeamOfficialReview
    this.forceUpdate()
  restoreAwayTeamOfficialReview: (retained = false) ->
    this.state.awayAttributes.hasOfficialReview = true
    this.clearTimeouts()
    if retained
      this.state.awayAttributes.officialReviewsRetained = this.state.awayAttributes.officialReviewsRetained + 1
  incrementPeriodTime: (ms = 1000) ->
    this.state.periodClockAttributes.time = this.state.periodClockAttributes.time + ms
  decrementPeriodTime: (ms = 1000) ->
    this.state.periodClockAttributes.time = this.state.periodClockAttributes.time - ms
  clearAlerts: () ->
    this.clearTimeouts()
    this.state.inUnofficialFinal = false
    this.state.inOfficialFinal = false
    this.state.homeAttributes.isUnofficialFinal = false
    this.state.homeAttributes.isOfficialFinal = false
    this.state.awayAttributes.isUnofficialFinal = false
    this.state.awayAttributes.isOfficialFinal = false
  clearTimeouts: () ->
    this.state.homeAttributes.isTakingTimeout = false
    this.state.awayAttributes.isTakingTimeout = false
    this.state.homeAttributes.isTakingOfficialReview = false
    this.state.awayAttributes.isTakingOfficialReview = false
  formatJamClock: () ->
    exports.wftda.functions.toClock(this.state.jamClockAttributes.time, false)
  formatPeriodClock: () ->
    exports.wftda.functions.toClock(this.state.periodClockAttributes.time, false)
  render: () ->
    #CS = Class Set
    timeoutSectionCS = cx
      'timeout-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["jam", "lineup", "timeout", "unofficial_final"]) == -1
    timeoutExplanationSectionCS = cx
      'timeout-explanation-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["timeout"]) == -1
    undoSectionCS = cx
      'undo-section': true
      'row': true
      'margin-top-05': true
      'hidden': true #$.inArray(this.state.state, ["jam", "lineup", "timeout", "unofficial_final", "final"]) == -1
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
      'hidden': $.inArray(this.state.state, ["pregame", "halftime",  "timeout", "unofficial_final", "final"]) == -1
    jamExplanationSectionCS = cx
      'jam-explanation-section': true
      'row': true
      'margin-top-05': true
      'hidden': $.inArray(this.state.state, ["lineup", "timeout", "unofficial_final"]) == -1
    homeTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': this.state.homeAttributes.isTakingOfficialReview
      'inactive': this.state.homeAttributes.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'bar': true
      'active': this.state.homeAttributes.isTakingTimeout && this.state.homeAttributes.timeouts == 2
      'inactive': this.state.homeAttributes.timeouts < 3
    homeTeamTimeouts2CS = cx
      'bar': true
      'active': this.state.homeAttributes.isTakingTimeout && this.state.homeAttributes.timeouts == 1
      'inactive': this.state.homeAttributes.timeouts < 2
    homeTeamTimeouts3CS = cx
      'bar': true
      'active': this.state.homeAttributes.isTakingTimeout && this.state.homeAttributes.timeouts == 0
      'inactive': this.state.homeAttributes.timeouts < 1
    awayTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': this.state.awayAttributes.isTakingOfficialReview
      'inactive': this.state.awayAttributes.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'bar': true
      'active': this.state.awayAttributes.isTakingTimeout && this.state.awayAttributes.timeouts == 2
      'inactive': this.state.awayAttributes.timeouts < 3
    awayTeamTimeouts2CS = cx
      'bar': true
      'active': this.state.awayAttributes.isTakingTimeout && this.state.awayAttributes.timeouts == 1
      'inactive': this.state.awayAttributes.timeouts < 2
    awayTeamTimeouts3CS = cx
      'bar': true
      'active': this.state.awayAttributes.isTakingTimeout && this.state.awayAttributes.timeouts == 0
      'inactive': this.state.awayAttributes.timeouts < 1
    <div className="jam-timer">
        <div className="row text-center">
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars home">
              <span className="jt-label">{this.state.homeAttributes.initials}</span>
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
                <div className="period-clock">{this.state.periodClockAttributes.display}</div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{this.state.state.replace(/_/g, ' ')}</strong>
                <div className="jam-clock">{this.state.jamClockAttributes.display}</div>
              </div>
            </div>
          </div>
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars away">
              <span className="jt-label">{this.state.awayAttributes.initials}</span>
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
    </div>
