cx = React.addons.classSet
exports = exports ? this
exports.JamTimer = React.createClass
  displayName: 'JamTimer'
  getInitialState: () ->
    state =
      handleModal: null
      id: @props.gameState.id
      componentId: exports.wftda.functions.uniqueId()
      state: @props.gameState.state
      jamNumber: @props.gameState.jamNumber
      periodNumber: @props.gameState.periodNumber
      homeAttributes: @props.gameState.homeAttributes
      awayAttributes: @props.gameState.awayAttributes
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
          reviewsRetained = @state.homeAttributes.officialReviewsRetained + 1
          @setState
            homeAttributes: $.extend @state.homeAttributes,
              hasOfficialReview: true
              officialReviewsRetained: reviewsRetained
        else
          reviewsRetained = @state.awayAttributes.officialReviewsRetained + 1
          @setState
            awayAttributes: $.extend @state.awayAttributes,
              hasOfficialReview: true
              officialReviewsRetained: reviewsRetained
      else
        #Set has official review to false
        if $parent.hasClass "home"
          @setState
            homeAttributes: $.extend @state.homeAttributes,
              hasOfficialReview: false
        else
          @setState
            awayAttributes: $.extend @state.awayAttributes,
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
          homeAttributes: $.extend @state.homeAttributes,
            timeouts: timeoutsRemaining
      else
        @setState
          awayAttributes: $.extend @state.awayAttributes,
            timeouts: timeoutsRemaining
    return null
  componentDidMount: () ->
    exports.wftda.ticks[@state.id] = exports.wftda.ticks[@state.id] || {}
    $dom = $(@getDOMNode())
    $jamClock = $dom.find(".jam-clock")
    $periodClock = $dom.find(".period-clock")
    #Send Events
    $dom.on 'click', '.start-jam-btn', null, (evt) =>
      @startJam()
      exports.dispatcher.trigger "jam_timer.start_jam", @buildOptions()
      console.log("start jam")
    $dom.on 'click', '.stop-jam-btn', null, (evt) =>
      @stopJam()
      exports.dispatcher.trigger "jam_timer.stop_jam", @buildOptions()
      console.log("stop jam")
    $dom.on 'click', '.start-lineup-btn', null, (evt) =>
      @startLineupClock()
      exports.dispatcher.trigger "jam_timer.start_lineup", @buildOptions()
      console.log("start lineup")
    $dom.on 'click', '.start-clock-btn', null, (evt) =>
      @props.clockManager.getClock("jamClock").start()
      exports.dispatcher.trigger "jam_timer.start_clock", @buildOptions()
      console.log("start clock")
    $dom.on 'click', '.stop-clock-btn', null, (evt) =>
      @props.clockManager.getClock("jamClock").stop()
      exports.dispatcher.trigger "jam_timer.stop_clock", @buildOptions()
      console.log("stop clock")
    $dom.on 'click', '.undo-btn', null, (evt) =>
      exports.dispatcher.trigger "jam_timer.undo", @buildOptions()
      console.log("undo")
    $dom.on 'click', '.timeout-section .timeout-btn', null, (evt) =>
      @startTimeout()
      exports.dispatcher.trigger "jam_timer.start_timeout", @buildOptions()
      console.log("start timeout")
    $dom.on 'click', '.official-timeout-btn', null, (evt) =>
      @markAsOfficialTimeout()
      exports.dispatcher.trigger "jam_timer.mark_as_official_timeout", @buildOptions()
      console.log("mark as official timeout")
    $dom.on 'click', '.home .timeout-btn', null, (evt) =>
      @markAsHomeTeamTimeout()
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_timeout", @buildOptions()
      console.log("mark as home team timeout")
    $dom.on 'click', '.home .review-btn', null, (evt) =>
      @markAsHomeTeamOfficialReview()
      exports.dispatcher.trigger "jam_timer.mark_as_home_team_review", @buildOptions()
      console.log("mark as home team official review")
    $dom.on 'click', '.away .timeout-btn', null, (evt) =>
      @markAsAwayTeamTimeout()
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_timeout", @buildOptions()
      console.log("mark as away team timeout")
    $dom.on 'click', '.away .review-btn', null, (evt) =>
      @markAsAwayTeamOfficialReview()
      exports.dispatcher.trigger "jam_timer.mark_as_away_team_review", @buildOptions()
      console.log("mark as away team official review")
    $dom.on 'click', '.ended-by-time-btn', null, (evt) =>
      $(".jam-explanation-section .btn").removeClass("btn-selected")
      $(evt.currentTarget).addClass("btn-selected")
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_time", @buildOptions()
      console.log("mark as ended by time")
    $dom.on 'click', '.jam-called-btn', null, (evt) =>
      $(".jam-explanation-section .btn").removeClass("btn-selected")
      $(evt.currentTarget).addClass("btn-selected")
      exports.dispatcher.trigger "jam_timer.mark_as_ended_by_calloff", @buildOptions()
      console.log("mark as ended by calloff")
    # Receive Events
    dispatcher.bind 'heartbeat', @handleHeartbeat
  componentWillUnmount: () ->
    @stopClocks()
  handleHeartBeat: (msg) ->
    gameState = exports.wftda.functions.camelize(msg)
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
    @props.clockManager.getClock("jamClock").stop()
    @props.clockManager.getClock("periodClock").stop()
  isPeriodClockRunning: () ->
    @props.clockManager.getClock("periodClock").isRunning()
  isJamClockRunning: () ->
    @props.clockManager.getClock("jamClock").isRunning()
  stopJamClock: () ->
    @props.clockManager.getClock("jamClock").stop()
  stopPeriodClock: () ->
    @props.clockManager.getClock("periodClock").stop()
  clearJammers: () ->
    @state.homeAttributes.jammer = {}
    @state.awayAttributes.jammer = {}
  startJam: () ->
    @clearTimeouts()
    @clearJammers()
    @props.clockManager.getClock("jamClock").reset(exports.wftda.constants.JAM_DURATION_IN_MS)
    @props.clockManager.getClock("jamClock").start()
    @props.clockManager.getClock("periodClock").start()
    @state.state = "jam"
    @state.homeAttributes.jamPoints = 0
    @state.awayAttributes.jamPoints = 0
    if @props.clockManager.getClock("periodClock").time == 0
      @state.periodNumber = @state.periodNumber + 1
      @props.clockManager.getClock("periodClock").reset(exports.wftda.constants.PERIOD_DURATION_IN_MS)
    @state.jamNumber = @state.jamNumber + 1
    for i in [@state.awayAttributes.jamStates.length+1 .. @state.jamNumber] by 1
      @state.awayAttributes.jamStates.push jamNumber: i
    for i in [@state.homeAttributes.jamStates.length+1 .. @state.jamNumber] by 1
      @state.homeAttributes.jamStates.push jamNumber: i
  stopJam: () ->
    @props.clockManager.getClock("jamClock").stop()
    @startLineupClock()
  startLineupClock: () ->
    @clearTimeouts()
    @props.clockManager.getClock("jamClock").reset(exports.wftda.constants.LINEUP_DURATION_IN_MS)
    @state.homeAttributes.jammerAttributes = {id: @state.homeAttributes.jammerAttributes.id}
    @state.awayAttributes.jammerAttributes = {id: @state.awayAttributes.jammerAttributes.id}
    @props.clockManager.getClock("jamClock").start()
    @props.clockManager.getClock("periodClock").start()
    @state.state = "lineup"
  setTimeToDerby: (time = 60*60*1000) ->
    @props.clockManager.getClock("periodClock").reset(0)
    @state.state = "pregame"
    @props.clockManager.getClock("jamClock").reset(time)
  restoreHomeTeamOfficialReview: () ->
    @state.homeAttributes.hasOfficialReview = true
  restoreAwayTeamOfficialReview: () ->
    @state.homeAttributes.hasOfficialReview = true
  setHomeTeamName: (name) ->
    @state.homeAttributes.name = name
  setAwayTeamName: (name) ->
    @state.awayAttributes.name = name
  setHomeTeamJammer: (name) ->
    @state.homeAttributes.jammerAttributes.name = name
  setAwayTeamJammer: (name) ->
    @state.awayAttributes.jammerAttributes.name = name
  setHomeTeamLead: () ->
    @state.homeAttributes.jammerAttributes.lead = true
  setAwayTeamLead: () ->
    @state.awayAttributes.jammerAttributes.lead = true
  setHomeTeamNotLead: () ->
    @state.homeAttributes.jammerAttributes.lead = false
  setAwayTeamNotLead: () ->
    @state.awayAttributes.jammerAttributes.lead = false
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
    @props.clockManager.getClock("jamClock").reset(exports.wftda.constants.TIMEOUT_DURATION_IN_MS)
    @props.clockManager.getClock("jamClock").start()
    @state.state = "timeout"
    @state.timeout = null
  markAsHomeTeamTimeout: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    newState = @state
    newState.state = "timeout"
    newState.timeout = "home_team_timeout"
    newState.homeAttributes.timeouts = @state.homeAttributes.timeouts - 1
    newState.homeAttributes.isTakingTimeout = true
    newState.undoFunction = @state.restoreHomeTeamTimeout
    @setState(newState)
  restoreHomeTeamTimeout: () ->
    @state.homeAttributes.timeouts = @state.homeAttributes.timeouts + 1
    @clearTimeouts()
  markAsAwayTeamTimeout: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    newState = @state
    newState.state = "timeout"
    newState.timeout = "away_team_timeout"
    newState.awayAttributes.timeouts = @state.awayAttributes.timeouts - 1
    newState.awayAttributes.isTakingTimeout = true
    newState.undoFunction = @state.restoreAwayTeamTimeout
    setState(newState)
  restoreAwayTeamTimeout: () ->
    @state.awayAttributes.timeouts = @state.awayAttributes.timeouts + 1
    @clearTimeouts()
  inTimeout: ()->
    @state.state == "team_timeout" || "official_timeout"
  markAsOfficialTimeout: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @props.clockManager.getClock("jamClock").reset(0)
    @props.clockManager.getClock("jamClock").start()
    newState = @state
    newState.state = "timeout"
    newState.timeout = "official_timeout"
    newState.inOfficialTimeout = true
    @setState(newState)
  markAsHomeTeamOfficialReview: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @props.clockManager.getClock("jamClock").reset(0)
    @props.clockManager.getClock("jamClock").start()
    newState = @state
    newState.homeAttributes.hasOfficialReview = false
    newState.homeAttributes.isTakingOfficialReview = true
    newState.state = "timeout"
    newState.timeout = "home_team_official_review"
    newState.undoFunction = @state.restoreHomeTeamOfficialReview
    @setState(newState)
  restoreHomeTeamOfficialReview: (retained = false) ->
    @state.homeAttributes.hasOfficialReview = true
    @clearTimeouts()
    if retained
      @state.homeAttributes.officialReviewsRetained = @state.homeAttributes.officialReviewsRetained + 1
  markAsAwayTeamOfficialReview: () ->
    if @inTimeout() == false
      @startTimeout()
    @clearTimeouts()
    @props.clockManager.getClock("jamClock").reset(0)
    @props.clockManager.getClock("jamClock").start()
    newState = @state
    newState.awayAttributes.hasOfficialReview = false
    newState.awayAttributes.isTakingOfficialReview = true
    newState.state = "timeout"
    newState.timeout = "away_team_official_review"
    newState.undoFunction = @state.restoreAwayTeamOfficialReview
    @setState(newState)
  restoreAwayTeamOfficialReview: (retained = false) ->
    @state.awayAttributes.hasOfficialReview = true
    @clearTimeouts()
    if retained
      @state.awayAttributes.officialReviewsRetained = @state.awayAttributes.officialReviewsRetained + 1
  clearAlerts: () ->
    @clearTimeouts()
    @state.inUnofficialFinal = false
    @state.inOfficialFinal = false
    @state.homeAttributes.isUnofficialFinal = false
    @state.homeAttributes.isOfficialFinal = false
    @state.awayAttributes.isUnofficialFinal = false
    @state.awayAttributes.isOfficialFinal = false
  clearTimeouts: () ->
    @state.homeAttributes.isTakingTimeout = false
    @state.awayAttributes.isTakingTimeout = false
    @state.homeAttributes.isTakingOfficialReview = false
    @state.awayAttributes.isTakingOfficialReview = false
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
    exports.dispatcher.trigger "jam_timer.update", @buildOptions
      state:
        state: @state.state
        jamNumber: @state.jamNumber
        periodNumber: @state.periodNumber
        jamClockAttributes: @props.clockManager.getClock("jamClock").serialize()
        periodClockAttributes: @props.clockManager.getClock("periodClock").serialize()
        homeAttributes: @state.homeAttributes
        awayAttributes: @state.awayAttributes
  handleJamEdit: (val) ->
    @setState {jamNumber: val}, @serverUpdate
  handlePeriodEdit: (val) ->
    @setState {periodNumber: val}, @serverUpdate
  handleJamClockEdit: (val) ->
    @props.clockManager.getClock("jamClock").time = val*1000
    @forceUpdate () ->
      @serverUpdate()
  handlePeriodClockEdit: (val) ->
    @props.clockManager.getClock("periodClock").time = val*1000
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
    $input.val(@props.clockManager.getClock("jamClock").time/1000)
    @openModal()
    @setState
      modalHandler: @handleJamClockEdit
  clickPeriodClockEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.clockManager.getClock("periodClock").time/1000)
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
      'active': @state.homeAttributes.isTakingOfficialReview
      'inactive': @state.homeAttributes.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'bar': true
      'active': @state.homeAttributes.isTakingTimeout && @state.homeAttributes.timeouts == 2
      'inactive': @state.homeAttributes.timeouts < 3
    homeTeamTimeouts2CS = cx
      'bar': true
      'active': @state.homeAttributes.isTakingTimeout && @state.homeAttributes.timeouts == 1
      'inactive': @state.homeAttributes.timeouts < 2
    homeTeamTimeouts3CS = cx
      'bar': true
      'active': @state.homeAttributes.isTakingTimeout && @state.homeAttributes.timeouts == 0
      'inactive': @state.homeAttributes.timeouts < 1
    awayTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': @state.awayAttributes.isTakingOfficialReview
      'inactive': @state.awayAttributes.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'bar': true
      'active': @state.awayAttributes.isTakingTimeout && @state.awayAttributes.timeouts == 2
      'inactive': @state.awayAttributes.timeouts < 3
    awayTeamTimeouts2CS = cx
      'bar': true
      'active': @state.awayAttributes.isTakingTimeout && @state.awayAttributes.timeouts == 1
      'inactive': @state.awayAttributes.timeouts < 2
    awayTeamTimeouts3CS = cx
      'bar': true
      'active': @state.awayAttributes.isTakingTimeout && @state.awayAttributes.timeouts == 0
      'inactive': @state.awayAttributes.timeouts < 1
    <div className="jam-timer">
        <div className="row text-center">
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars home">
              <span className="jt-label">{@state.homeAttributes.initials}</span>
              <div className={homeTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@state.homeAttributes.officialReviewsRetained}</div>
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
                <div className="period-clock" onClick={@clickPeriodClockEdit}>{@props.clockManager.getClock("periodClock").display()}</div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{@state.state.replace(/_/g, ' ')}</strong>
                <div className="jam-clock" onClick={@clickJamClockEdit}>{@props.clockManager.getClock("jamClock").display()}</div>
              </div>
            </div>
          </div>
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars away">
              <span className="jt-label">{@state.awayAttributes.initials}</span>
              <div className={awayTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@state.awayAttributes.officialReviewsRetained}</div>
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
