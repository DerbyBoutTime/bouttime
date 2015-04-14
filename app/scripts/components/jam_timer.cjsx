React = require 'react/addons'
$ = require 'jquery'
constants = require '../constants.coffee'
functions = require '../functions.coffee'
CountdownClock = require '../clock.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamTimer'
  getInitialState: () ->
    state =
      handleModal: null
      id: @props.gameState.id
      componentId: functions.uniqueId()
      state: @props.gameState.state
      jamNumber: @props.gameState.jamNumber
      periodNumber: @props.gameState.periodNumber
      home: @props.gameState.home
      away: @props.gameState.away
      jamClock: new CountdownClock
        time: @props.gameState.jamClock.time ? constants.JAM_DURATION_IN_MS
        warningTime: constants.JAM_WARNING_IN_MS
        refreshRateInMs: constants.CLOCK_REFRESH_RATE_IN_MS
        selector: ".jam-clock"
      periodClock: new CountdownClock
        time: @props.gameState.periodClock.time ? constants.PERIOD_DURATION_IN_MS
        warningTime: constants.JAM_WARNING_IN_MS
        refreshRateInMs: constants.CLOCK_REFRESH_RATE_IN_MS
        selector: ".period-clock"
  componentWillReceiveProps: (nextProps) ->
  buildOptions: (opts = {}) ->
    std_opts =
      role: 'Jam Timer'
      state: @state
    $.extend(std_opts, opts)
  handleToggleTimeoutBar: (evt) ->
    $target = $(evt.target)
    $parent = $target.closest(".timeout-bars").first()
    console.log $target.closest(".timeout-bars").first()
    if $target.hasClass "official-review"
      if $target.hasClass "inactive"
        #Set has official review to true
        #Increment official reviews retained
        if $parent.hasClass "home"
          reviewsRetained = @state.home.officialReviewsRetained + 1
          @setState
            home: $.extend @state.home,
              hasOfficialReview: true
              officialReviewsRetained: reviewsRetained
        else
          reviewsRetained = @state.away.officialReviewsRetained + 1
          @setState
            away: $.extend @state.away,
              hasOfficialReview: true
              officialReviewsRetained: reviewsRetained
      else
        #Set has official review to false
        if $parent.hasClass "home"
          @setState
            home: $.extend @state.home,
              hasOfficialReview: false
        else
          @setState
            away: $.extend @state.away,
              hasOfficialReview: false
    else #Its a normal timeout not an official review
      timeoutsRemaining = 0
      if $target.hasClass "inactive"
        timeoutsRemaining = timeoutsRemaining + 1
      timeoutsRemaining = timeoutsRemaining + $target.nextAll(".bar").length
      console.log "Setting remaining timeouts to #{timeoutsRemaining}"
      #Set remaining timeouts
      if $parent.hasClass "home"
        @setState
          home: $.extend @state.home,
            timeouts: timeoutsRemaining
      else
        @setState
          away: $.extend @state.away,
            timeouts: timeoutsRemaining
    return null
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    $jamClock = $dom.find(".jam-clock")
    $periodClock = $dom.find(".period-clock")

    #Propagate clock events
    $jamClock.on "tick", (evt, options) =>
      #console.log "jam clock tick", evt, options
      @forceUpdate() #Need to force update because state hasn't changed
    $periodClock.on "tick", (evt, options) =>
      #console.log "period clock tick", evt, options
      @forceUpdate() #Need to force update because state hasn't changed

    #Send Events
    $dom.on 'click', '.start-jam-btn', null, (evt) =>
      @startJam()
      console.log("start jam")
    $dom.on 'click', '.stop-jam-btn', null, (evt) =>
      @stopJam()
      console.log("stop jam")
    $dom.on 'click', '.start-lineup-btn', null, (evt) =>
      @startLineupClock()
      console.log("start lineup")
    $dom.on 'click', '.start-clock-btn', null, (evt) =>
      @state.jamClock.start()
      console.log("start clock")
    $dom.on 'click', '.stop-clock-btn', null, (evt) =>
      @state.jamClock.stop()
      console.log("stop clock")
    $dom.on 'click', '.undo-btn', null, (evt) =>
      console.log("undo")
    $dom.on 'click', '.timeout-section .timeout-btn', null, (evt) =>
      @startTimeout()
      console.log("start timeout")
    $dom.on 'click', '.official-timeout-btn', null, (evt) =>
      @markAsOfficialTimeout()
      console.log("mark as official timeout")
    $dom.on 'click', '.home .timeout-btn', null, (evt) =>
      @markAsHomeTeamTimeout()
      console.log("mark as home team timeout")
    $dom.on 'click', '.home .review-btn', null, (evt) =>
      @markAsHomeTeamOfficialReview()
      console.log("mark as home team official review")
    $dom.on 'click', '.away .timeout-btn', null, (evt) =>
      @markAsAwayTeamTimeout()
      console.log("mark as away team timeout")
    $dom.on 'click', '.away .review-btn', null, (evt) =>
      @markAsAwayTeamOfficialReview()
      console.log("mark as away team official review")
    $dom.on 'click', '.ended-by-time-btn', null, (evt) =>
      $(".jam-explanation-section .btn").removeClass("btn-selected")
      $(evt.currentTarget).addClass("btn-selected")
      console.log("mark as ended by time")
    $dom.on 'click', '.jam-called-btn', null, (evt) =>
      $(".jam-explanation-section .btn").removeClass("btn-selected")
      $(evt.currentTarget).addClass("btn-selected")
      console.log("mark as ended by calloff")
    # Receive Events
  componentWillUnmount: () ->
    @stopClocks()
  handleHeartBeat: (msg) ->
    gameState = functions.camelize(msg)
    console.log "Heartbeat"
  setUnofficialFinal: () ->
    @state.inUnofficialFinal = true
    @state.inOfficialFinal =  false
  setOfficialFinal: () ->
    @state.inUnofficialFinal = false
    @state.inOfficialFinal =  true
  receiveHeartbeat: (evt, data) ->
    @state.lastHeartbeat = evt.timestamp
  stopClocks: () ->
    @state.jamClock.stop()
    @state.periodClock.stop()
  isPeriodClockRunning: () ->
    @state.periodClock.isRunning()
  isJamClockRunning: () ->
    @state.jamClock.isRunning()
  stopJamClock: () ->
    @state.jamClock.stop()
  stopPeriodClock: () ->
    @state.periodClock.stop()
  clearJammers: () ->
    @state.home.jammer = {}
    @state.away.jammer = {}
  startJam: () ->
    @clearTimeouts()
    @clearJammers()
    @state.jamClock.reset(constants.JAM_DURATION_IN_MS)
    @state.jamClock.start()
    @state.periodClock.start()
    @state.state = "jam"
    @state.home.jamPoints = 0
    @state.away.jamPoints = 0
    if @state.periodClock.time == 0
      @state.periodNumber = @state.periodNumber + 1
      @state.periodClock.reset(constants.PERIOD_DURATION_IN_MS)
    @state.jamNumber = @state.jamNumber + 1
    for i in [@state.away.getJams().length+1 .. @state.jamNumber] by 1
      @state.away.getJams().push jamNumber: i
    for i in [@state.home.getJams().length+1 .. @state.jamNumber] by 1
      @state.home.getJams().push jamNumber: i
  stopJam: () ->
    @state.jamClock.stop()
    @startLineupClock()
  startLineupClock: () ->
    @clearTimeouts()
    @state.jamClock.reset(constants.LINEUP_DURATION_IN_MS)
    @state.home.jammerAttributes = {id: @state.home.jammerAttributes.id}
    @state.away.jammerAttributes = {id: @state.away.jammerAttributes.id}
    @state.jamClock.start()
    @state.periodClock.start()
    @state.state = "lineup"
  setTimeToDerby: (time = 60*60*1000) ->
    @state.periodClock.reset(0)
    @state.state = "pregame"
    @state.jamClock.reset(time)
  restoreHomeTeamOfficialReview: () ->
    @state.home.hasOfficialReview = true
  restoreAwayTeamOfficialReview: () ->
    @state.home.hasOfficialReview = true
  setHomeTeamName: (name) ->
    @state.home.name = name
  setAwayTeamName: (name) ->
    @state.away.name = name
  setHomeTeamJammer: (name) ->
    @state.home.jammerAttributes.name = name
  setAwayTeamJammer: (name) ->
    @state.away.jammerAttributes.name = name
  setHomeTeamLead: () ->
    @state.home.jammerAttributes.lead = true
  setAwayTeamLead: () ->
    @state.away.jammerAttributes.lead = true
  setHomeTeamNotLead: () ->
    @state.home.jammerAttributes.lead = false
  setAwayTeamNotLead: () ->
    @state.away.jammerAttributes.lead = false
  incrementPeriodNumber: (num = 1) ->
    @state.periodNumber =  @state.periodNumber + parseInt(num)
  decrementPeriodNumber: (num = 1) ->
    @state.periodNumber =  @state.periodNumber - parseInt(num)
  setPeriod: (num) ->
    @state.periodNumber =  parseInt(num)
  incrementJamNumber: (num = 1) ->
    @state.jamNumber =  @state.jamNumber + parseInt(num)
  decrementJamNumber: (num = 1) ->
    @state.jamNumber =  @state.jamNumber - parseInt(num)
  setJamNumber: (num) ->
    @state.jamNumber =  parseInt(num)
  startTimeout: () ->
    @stopClocks()
    @state.jamClock.reset(constants.TIMEOUT_DURATION_IN_MS)
    @state.jamClock.start()
    @state.state = "timeout"
    @state.timeout = null
  markAsHomeTeamTimeout: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @state.state = "timeout"
    @state.timeout = "home_team_timeout"
    @state.home.timeouts = @state.home.timeouts - 1
    @state.home.isTakingTimeout = true
    @state.undoFunction = @state.restoreHomeTeamTimeout
    @forceUpdate()
  restoreHomeTeamTimeout: () ->
    @state.home.timeouts = @state.home.timeouts + 1
    @clearTimeouts()
  markAsAwayTeamTimeout: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @state.state = "timeout"
    @state.timeout = "away_team_timeout"
    @state.away.timeouts = @state.away.timeouts - 1
    @state.away.isTakingTimeout = true
    @state.undoFunction = @state.restoreAwayTeamTimeout
    @forceUpdate()
  restoreAwayTeamTimeout: () ->
    @state.away.timeouts = @state.away.timeouts + 1
    @clearTimeouts()
  inTimeout: ()->
    @state.state == "team_timeout" || "official_timeout"
  markAsOfficialTimeout: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @state.jamClock.reset(0)
    @state.jamClock.start()
    @state.state = "timeout"
    @state.timeout = "official_timeout"
    @state.inOfficialTimeout = true
    @forceUpdate()
  markAsHomeTeamOfficialReview: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @state.jamClock.reset(0)
    @state.jamClock.start()
    @state.home.hasOfficialReview = false
    @state.home.isTakingOfficialReview = true
    @state.state = "timeout"
    @state.timeout = "home_team_official_review"
    @state.undoFunction = @state.restoreHomeTeamOfficialReview
    @forceUpdate()
  restoreHomeTeamOfficialReview: (retained = false) ->
    @state.home.hasOfficialReview = true
    @clearTimeouts()
    if retained
      @state.home.officialReviewsRetained = @state.home.officialReviewsRetained + 1
  markAsAwayTeamOfficialReview: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @state.jamClock.reset(0)
    @state.jamClock.start()
    @state.away.hasOfficialReview = false
    @state.away.isTakingOfficialReview = true
    @state.state = "timeout"
    @state.timeout = "away_team_official_review"
    @state.undoFunction = @state.restoreAwayTeamOfficialReview
    @forceUpdate()
  restoreAwayTeamOfficialReview: (retained = false) ->
    @state.away.hasOfficialReview = true
    @clearTimeouts()
    if retained
      @state.away.officialReviewsRetained = @state.away.officialReviewsRetained + 1
  clearAlerts: () ->
    @clearTimeouts()
    @state.inUnofficialFinal = false
    @state.inOfficialFinal = false
    @state.home.isUnofficialFinal = false
    @state.home.isOfficialFinal = false
    @state.away.isUnofficialFinal = false
    @state.away.isOfficialFinal = false
  clearTimeouts: () ->
    @state.home.isTakingTimeout = false
    @state.away.isTakingTimeout = false
    @state.home.isTakingOfficialReview = false
    @state.away.isTakingOfficialReview = false
  openModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $modal.modal('show')
  handleModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $input = $(@refs.modalInput.getDOMNode())
    $modal.modal('hide')
    val = parseInt($input.val())
    @state.modalHandler(val)
  serverUpdate: () ->
    console.log @state
  handleJamEdit: (val) ->
    @setState {jamNumber: val}, @serverUpdate
  handlePeriodEdit: (val) ->
    @setState {periodNumber: val}, @serverUpdate
  handleJamClockEdit: (val) ->
    @state.jamClock.time = val*1000
    @forceUpdate () ->
      @serverUpdate()
  handlePeriodClockEdit: (val) ->
    @state.periodClock.time = val*1000
    @forceUpdate () ->
      @serverUpdate()
  clickJamEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@state.jamNumber)
    @openModal()
    @setState
      modalHandler: @handleJamEdit
  clickPeriodEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@state.periodNumber)
    @openModal()
    @setState
      modalHandler: @handlePeriodEdit
  clickJamClockEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@state.jamClock.time/1000)
    @openModal()
    @setState
      modalHandler: @handleJamClockEdit
  clickPeriodClockEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@state.periodClock.time/1000)
    @openModal()
    @setState
      modalHandler: @handlePeriodClockEdit
  render: () ->
    #CS = Class Set
    timeoutSectionCS = cx
      'timeout-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["jam", "lineup", "timeout", "unofficial_final"]) == -1
    timeoutExplanationSectionCS = cx
      'timeout-explanation-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["timeout"]) == -1
    undoSectionCS = cx
      'undo-section': true
      'row': true
      'margin-xs': true
      'hidden': true #$.inArray(@state.state, ["jam", "lineup", "timeout", "unofficial_final", "final"]) == -1
    startClockSectionCS = cx
      'start-clock-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["pregame", "halftime", "final"]) == -1
    stopClockSectionCS = cx
      'stop-clock-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["pregame"]) == -1
    startJamSectionCS = cx
      'start-jam-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["pregame", "halftime", "lineup"]) == -1
    stopJamSectionCS = cx
      'stop-jam-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["jam"]) == -1
    startLineupSectionCS = cx
      'start-lineup-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["pregame", "halftime",  "timeout", "unofficial_final", "final"]) == -1
    jamExplanationSectionCS = cx
      'jam-explanation-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@state.state, ["lineup", "timeout", "unofficial_final"]) == -1
    homeTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': @state.home.isTakingOfficialReview
      'inactive': @state.home.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'bar': true
      'active': @state.home.isTakingTimeout && @state.home.timeouts == 2
      'inactive': @state.home.timeouts < 3
    homeTeamTimeouts2CS = cx
      'bar': true
      'active': @state.home.isTakingTimeout && @state.home.timeouts == 1
      'inactive': @state.home.timeouts < 2
    homeTeamTimeouts3CS = cx
      'bar': true
      'active': @state.home.isTakingTimeout && @state.home.timeouts == 0
      'inactive': @state.home.timeouts < 1
    awayTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': @state.away.isTakingOfficialReview
      'inactive': @state.away.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'bar': true
      'active': @state.away.isTakingTimeout && @state.away.timeouts == 2
      'inactive': @state.away.timeouts < 3
    awayTeamTimeouts2CS = cx
      'bar': true
      'active': @state.away.isTakingTimeout && @state.away.timeouts == 1
      'inactive': @state.away.timeouts < 2
    awayTeamTimeouts3CS = cx
      'bar': true
      'active': @state.away.isTakingTimeout && @state.away.timeouts == 0
      'inactive': @state.away.timeouts < 1
    <div className="jam-timer">
        <div className="row text-center">
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars home">
              <span className="jt-label">{@state.home.initials}</span>
              <div className={homeTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@state.home.officialReviewsRetained}</div>
              <div className={homeTeamTimeouts1CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={homeTeamTimeouts2CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={homeTeamTimeouts3CS} onClick={@handleToggleTimeoutBar}></div>
            </div>
          </div>
          <div className="col-md-8 col-xs-8">
            <div className="row">
              <div className="col-xs-12">
                <strong>
                  <span className="jt-label pull-left" onClick={@clickPeriodEdit}>
                    Period {@state.periodNumber}
                  </span>
                  <span className="jt-label pull-right" onClick={@clickJamEdit}>
                    Jam {@state.jamNumber}
                  </span>
                </strong>
              </div>
              <div className="col-md-12 col-xs-12">
                <div className="period-clock" onClick={@clickPeriodClockEdit}>{@state.periodClock.display()}</div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{@state.state.replace(/_/g, ' ')}</strong>
                <div className="jam-clock" onClick={@clickJamClockEdit}>{@state.jamClock.display()}</div>
              </div>
            </div>
          </div>
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars away">
              <span className="jt-label">{@state.away.initials}</span>
              <div className={awayTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@state.away.officialReviewsRetained}</div>
              <div className={awayTeamTimeouts1CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={awayTeamTimeouts2CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={awayTeamTimeouts3CS} onClick={@handleToggleTimeoutBar}></div>
            </div>
          </div>
        </div>
        <div className={timeoutSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn timeout-btn">TIMEOUT</button>
          </div>
        </div>
        <div className={timeoutExplanationSectionCS}>
          <div className="col-xs-4">
            <div className="home">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn timeout-btn">TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn review-btn">
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="col-md-4 col-xs-4">
            <button className="bt-btn official-timeout-btn">
              <div>OFFICIAL</div>
              <div>TIMEOUT</div>
            </button>
          </div>
          <div className="col-md-4 col-xs-4 timeouts">
            <div className="away">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn timeout-btn">TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn review-btn">
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
            <button className="bt-btn undo-btn">UNDO</button>
          </div>
        </div>
        <div className={startClockSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn start-clock-btn">START CLOCK</button>
          </div>
        </div>
        <div className={stopClockSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn stop-clock-btn">STOP CLOCK</button>
          </div>
        </div>
        <div className={startJamSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn start-jam-btn">START JAM</button>
          </div>
        </div>
        <div className={stopJamSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn stop-jam-btn">STOP JAM</button>
          </div>
        </div>
        <div className={startLineupSectionCS}>
          <div className="col-xs-12 start-lineup-section">
            <button className="bt-btn start-lineup-btn">START LINEUP</button>
          </div>
        </div>
        <div className={jamExplanationSectionCS}>
          <div className="col-xs-6">
            <button className="bt-btn jam-called-btn">
              JAM CALLED
            </button>
          </div>
          <div className="col-xs-6">
            <button className="bt-btn ended-by-time-btn">
              ENDED BY TIME
            </button>
          </div>
        </div>
        <div className="modal" ref="modal">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title">Edit</h4>
              </div>
              <div className="modal-body">
                <input type="number" className="form-control" ref="modalInput"/>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-primary" onClick={@handleModal}>Save changes</button>
              </div>
            </div>
          </div>
        </div>
    </div>
