exports = exports ? this
exports.classes = exports.classes ? {}
exports.classes.JamTimer = class JamTimer
  constructor: (clockManager, gameState, @setState, @dispatcher = false, @debug = false) ->
    @clockManager = clockManager
    @state = gameState
    @dispatcherPrefix = "jam_timer"
    @clockManager.addTickListener (clocks) =>
      cm = @clockManager.serialize()
      @state[alias+"Attributes"] = clock for alias, clock of cm
      @dispatch "tick", cm
  log: (messages...) =>
    console.log(messages) if @debug
  dispatch: (eventName, options) =>
    unless options?
      options = @_buildOptions()
    if @dispatcher
      exports.dispatcher.trigger "#{@dispatcherPrefix}.#{eventName}", options
      @setState(@state)
  startClock: () =>
    @log("start clock")
    @clockManager.getClock("jamClock").start()
    @dispatch "start_clock"
  stopClock: () =>
    @log("stop clock")
    @clockManager.getClock("jamClock").stop()
    @dispatch "stop_clock"
  startJam: () =>
    @log("start jam")
    @_clearTimeouts()
    @clockManager.getClock("jamClock").reset(exports.wftda.constants.JAM_DURATION_IN_MS)
    @clockManager.getClock("jamClock").start()
    @clockManager.getClock("periodClock").start()
    @state.state = "jam"
    @state.homeAttributes.jamPoints = 0
    @state.awayAttributes.jamPoints = 0
    if @clockManager.getClock("periodClock").time == 0
      @state.periodNumber = @state.periodNumber + 1
      @clockManager.getClock("periodClock").reset(exports.wftda.constants.PERIOD_DURATION_IN_MS)
    @state.jamNumber = @state.jamNumber + 1
    for i in [@state.awayAttributes.jamStates.length+1 .. @state.jamNumber] by 1
      @state.awayAttributes.jamStates.push jamNumber: i
    for i in [@state.homeAttributes.jamStates.length+1 .. @state.jamNumber] by 1
      @state.homeAttributes.jamStates.push jamNumber: i
    @dispatch "start_jam"
  stopJam: () =>
    @log("stop jam")
    @clockManager.getClock("jamClock").stop()
    @startLineup()
    @dispatch "stop_jam"
  startLineup: () =>
    @log("start lineup")
    @_clearTimeouts()
    @clockManager.getClock("jamClock").reset(exports.wftda.constants.LINEUP_DURATION_IN_MS)
    @state.homeAttributes.jammerAttributes = {id: @state.homeAttributes.jammerAttributes.id}
    @state.awayAttributes.jammerAttributes = {id: @state.awayAttributes.jammerAttributes.id}
    @clockManager.getClock("jamClock").start()
    @clockManager.getClock("periodClock").start()
    @state.state = "lineup"
    @dispatch "start_lineup"
  startPregame: (time = 60*60*1000) =>
    @log("start pregram")
    @clockManager.getClock("periodClock").reset(0)
    @state.state = "pregame"
    @clockManager.getClock("jamClock").reset(time)
    @dispatch "start_pregame"
  startHalftime: (time = 30*60*1000) =>
    @log("start halftime")
    @clockManager.getClock("periodClock").reset(0)
    @state.state = "halftime"
    @clockManager.getClock("jamClock").reset(time)
    @dispatch "start_halftime"
  startUnofficialFinal: () =>
    @log("start unofficial final")
    @state.inUnofficialFinal = true
    @state.inOfficialFinal =  false
    @dispatch "start_unofficial_final"
  startOfficialFinal: () =>
    @log("start official final")
    @state.inUnofficialFinal = false
    @state.inOfficialFinal =  true
    @dispatch "start_official_final"
  startTimeout: () =>
    @log("start timeout")
    @_stopClocks()
    @clockManager.getClock("jamClock").reset(exports.wftda.constants.TIMEOUT_DURATION_IN_MS)
    @clockManager.getClock("jamClock").start()
    @state.state = "timeout"
    @state.timeout = null
    @dispatch "start_timeout"
  setTimeoutAsOfficialTimeout: () =>
    @log("set timeout as official timeout")
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @clockManager.getClock("jamClock").reset(0)
    @clockManager.getClock("jamClock").start()
    @state.state = "timeout"
    @state.timeout = "official_timeout"
    @state.inOfficialTimeout = true
    @dispatch "mark_as_official_timeout"
  setTimeoutAsHomeTeamTimeout: () =>
    @log("set timeout as home team timeout")
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @state.state = "timeout"
    @state.timeout = "home_team_timeout"
    @state.homeAttributes.timeouts = @state.homeAttributes.timeouts - 1
    @state.homeAttributes.isTakingTimeout = true
    @dispatch "mark_as_home_team_timeout"
  setTimeoutAsHomeTeamOfficialReview: () =>
    @log("set timeout as home team official review")
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @clockManager.getClock("jamClock").reset(0)
    @clockManager.getClock("jamClock").start()
    @state.homeAttributes.hasOfficialReview = false
    @state.homeAttributes.isTakingOfficialReview = true
    @state.state = "timeout"
    @state.timeout = "home_team_official_review"
    @dispatch "mark_as_home_team_review"
  setTimeoutAsAwayTeamTimeout: () =>
    @log("set timeout as away team timeout")
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @state.state = "timeout"
    @state.timeout = "away_team_timeout"
    @state.awayAttributes.timeouts = @state.awayAttributes.timeouts - 1
    @state.awayAttributes.isTakingTimeout = true
    @dispatch "mark_as_away_team_timeout"
  setTimeoutAsAwayTeamOfficialReview: () =>
    @log("set timeout as away team official review")
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @clockManager.getClock("jamClock").reset(0)
    @clockManager.getClock("jamClock").start()
    @state.awayAttributes.hasOfficialReview = false
    @state.awayAttributes.isTakingOfficialReview = true
    @state.state = "timeout"
    @state.timeout = "away_team_official_review"
    @dispatch "mark_as_away_team_review"
  setJamEndedByTime: () =>
    @log("set jam as ended by time")
    @dispatch "mark_as_ended_by_time"
  setJamEndedByCalloff: () =>
    @log("set jam as ended by calloff")
    @dispatch "mark_as_ended_by_calloff"
  setJamClock: (val) =>
    @log("set jam clock")
    @clockManager.getClock("jamClock").time = val*1000
    @dispatch "set_jam_clock"
  setPeriodClock: (val) =>
    @log("set period clock")
    @clockManager.getClock("periodClock").time = val*1000
    @dispatch "set_period_clock"
  setHomeTeamTimeouts: (val) =>
    @log("set home team timeouts")
    @state.homeAttributes.timeouts = parseInt(val)
    @dispatch "set_home_team_timeouts"
  setAwayTeamTimeouts: (val) =>
    @log("set away team timeouts")
    @state.awayAttributes.timeouts = parseInt(val)
    @dispatch "set_away_team_timeouts"
  setPeriodNumber: (val) =>
    @log("set period number")
    @state.periodNumber = parseInt(val)
    @dispatch "set_period_number"
  setJamNumber: (val) =>
    @log("set jam number")
    @state.jamNumber = parseInt(val)
    @dispatch "set_jam_number"
  removeHomeTeamOfficialReview: () =>
    @log("remove home team official review")
    @state.homeAttributes.hasOfficialReview = false
    @state.homeAttributes.officialReviewsRetained = @state.homeAttributes.officialReviewsRetained - 1
    @dispatch "remove_home_team_official_review"
  removeAwayTeamOfficialReview: () =>
    @log("remove away team official review")
    @state.awayAttributes.hasOfficialReview = false
    @state.awayAttributes.officialReviewsRetained = @state.awayAttributes.officialReviewsRetained - 1
    @dispatch "remove_away_team_official_review"
  restoreHomeTeamOfficialReview: () =>
    @log("restore home team official review")
    @state.homeAttributes.hasOfficialReview = true
    @_clearTimeouts()
    @state.homeAttributes.officialReviewsRetained = @state.homeAttributes.officialReviewsRetained + 1
    @dispatch "restore_home_team_official_review"
  restoreAwayTeamOfficialReview: (retained = false) =>
    @log("restore away team official review")
    @state.awayAttributes.hasOfficialReview = true
    @_clearTimeouts()
    @state.awayAttributes.officialReviewsRetained = @state.awayAttributes.officialReviewsRetained + 1
    @dispatch "restore_away_team_official_review"
  _inTimeout: ()->
      @state.state == "team_timeout" || @state.state == "official_timeout"
  _clearAlerts: () =>
    @_clearTimeouts()
    @state.inUnofficialFinal = false
    @state.inOfficialFinal = false
    @state.homeAttributes.isUnofficialFinal = false
    @state.homeAttributes.isOfficialFinal = false
    @state.awayAttributes.isUnofficialFinal = false
    @state.awayAttributes.isOfficialFinal = false
  _clearTimeouts: () =>
    @state.homeAttributes.isTakingTimeout = false
    @state.awayAttributes.isTakingTimeout = false
    @state.homeAttributes.isTakingOfficialReview = false
    @state.awayAttributes.isTakingOfficialReview = false
  _buildOptions: (opts = {}) =>
    std_opts =
      role: 'Jam Timer'
      state: @state.state
    $.extend(std_opts, opts)
  _stopClocks: () ->
    @clockManager.getClock("jamClock").stop()
    @clockManager.getClock("periodClock").stop()