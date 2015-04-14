functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
Store = require './store.coffee'
Clocks = require '../clock.coffee'
Team = require './team.coffee'
{ActionTypes} = require '../constants.coffee'
constants = require '../constants.coffee'
class GameState extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    game = @find(action.gameId)
    switch action.type
      when ActionTypes.START_CLOCK
        game.startClock()
      when ActionTypes.STOP_CLOCK
        game.stopClock()
      when ActionTypes.START_JAM
        game.startJam()
      when ActionTypes.STOP_JAM
        game.stopJam()
      when ActionTypes.START_LINEUP
        game.startLineup()
      when ActionTypes.START_PREGAME
        game.startPregame()
      when ActionTypes.START_HALFTIME
        game.startHalftime()
      when ActionTypes.START_UNOFFICIAL_FINAL
        game.startUnofficialFinal()
      when ActionTypes.START_OFFICIAL_FINAL
        game.startOfficialFinal()
      when ActionTypes.START_TIMEOUT
        game.startTimeout()
      when ActionTypes.SET_TIMEOUT_AS_OFFICIAL_TIMEOUT
        game.setTimeoutAsOfficialTimeout()
      when ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_TIMEOUT
        game.setTimeoutAsHomeTeamTimeout()
      when ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_OFFICIAL_REVIEW
        game.setTimeoutAsHomeTeamOfficialReview()
      when ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_TIMEOUT
        game.setTimeoutAsAwayTeamTimeout()
      when ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_OFFICIAL_REVIEW
        game.setTimeoutAsAwayTeamOfficialReview()
      when ActionTypes.SET_JAM_ENDED_BY_TIME
        game.setJamEndedByTime()
      when ActionTypes.SET_JAM_ENDED_BY_CALLOFF
        game.setJamEndedByCalloff()
      when ActionTypes.SET_JAM_CLOCK
        game.setJamClock()
      when ActionTypes.SET_PERIOD_CLOCK
        game.setPeriodClock()
      when ActionTypes.SET_HOME_TEAM_TIMEOUTS
        game.setHomeTeamTimeouts()
      when ActionTypes.SET_AWAY_TEAM_TIMEOUTS
        game.setAwayTeamTimeouts()
      when ActionTypes.SET_PERIOD_NUMBER
        game.setPeriodNumber()
      when ActionTypes.SET_JAM_NUMBER
        game.setJamNumber()
      when ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
        game.removeHomeTeamOfficialReview()
      when ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
        game.removeAwayTeamOfficialReview()
      when ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
        game.restoreHomeTeamOfficialReview()
      when ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
        game.restoreAwayTeamOfficialReview()
    game.save()
    @emitChange()
  constructor: (options={}) ->
    super options
    @debug = options.debug || false
    @state = options.state || 'pregame'
    @jamNumber = options.jamNumber || 0
    @periodNumber = options.periodNumber || 0
    @clockManager = new Clocks.ClockManager()
    @clockManager.addClock "jamClock",
      time: options.JamClockTime ? constants.JAM_DURATION_IN_MS
      warningTime: constants.JAM_WARNING_IN_MS
      refreshRateInMs: constants.CLOCK_REFRESH_RATE_IN_MS
      selector: ".jam-clock"
    @clockManager.addClock "periodClock",
      time: options.periodClockTime ? constants.PERIOD_DURATION_IN_MS
      warningTime: constants.JAM_WARNING_IN_MS
      refreshRateInMs: constants.CLOCK_REFRESH_RATE_IN_MS
      selector: ".period-clock"
    @jamClock = @clockManager.getClock("jamClock")
    @periodClock = @clockManager.getClock("periodClock")
    @home = options.home || new Team()
    @away = options.away || new Team()
    @penalties = [
      {name: "High Block"
      code: "A"}
      ,
      {name: "Insubordination"
      code: "N"}
      ,
      {name: "Back Block"
      code: "B"}
      ,
      {name: "Skating Out of Bnds."
      code: "S"}
      ,
      {name: "Elbows"
      code: "E"}
      ,
      {name: "Cutting the Track"
      code: "X"}
      ,
      {name: "Forearms"
      code: "F"}
      ,
      {name: "Delay of Game"
      code: "Z"}
      ,
      {name: "Misconduct"
      code: "G"}
      ,
      {name: "Dir. of Game Play"
      code: "C"}
      ,
      {name: "Blocking with Head"
      code: "H"}
      ,
      {name: "Out of Bounds"
      code: "O"}
      ,
      {name: "Low Block"
      code: "L"}
      ,
      {name: "Out of Play"
      code: "P"}
      ,
      {name: "Multi-Player Block"
      code: "M"}
      ,
      {name: "Illegal Procedure"
      code: "I"}
      ,
      {name: "Gross Misconduct"
      code: "G"}
    ]
  save: () ->
    super()
    @home.save()
    @away.save()
  getCurrentJam: (team) ->
    (jam for jam in team.getJams() when jam.jamNumber is @jamNumber)[0]
  startClock: ()->
    @jamClock.start()
  stopClock: () ->
    @jamClock.stop()
  startJam: () ->
    @_clearTimeouts()
    @jamClock.reset(constants.JAM_DURATION_IN_MS)
    @jamClock.start()
    @periodClock.start()
    @state = "jam"
    @home.jamPoints = 0
    @away.jamPoints = 0
    if @periodClock.time == 0
      @periodNumber = @periodNumber + 1
      @periodClock.reset(constants.PERIOD_DURATION_IN_MS)
    @jamNumber = @jamNumber + 1
    for i in [@away.getJams().length+1 .. @jamNumber] by 1
      @away.getJams().push jamNumber: i
    for i in [@home.getJams().length+1 .. @jamNumber] by 1
      @home.getJams().push jamNumber: i
  stopJam: () =>
    @jamClock.stop()
    @startLineup()
  startLineup: () =>
    @_clearTimeouts()
    @jamClock.reset(constants.LINEUP_DURATION_IN_MS)
    @jamClock.start()
    @periodClock.start()
    @state = "lineup"
  startPregame: (time = constants.PREGAME_DURATION_IN_MS) =>
    @periodClock.reset(0)
    @state = "pregame"
    @jamClock.reset(time)
  startHalftime: (time = HALFTIME_DURATION_IN_MS) =>
    @periodClock.reset(0)
    @state = "halftime"
    @jamClock.reset(time)
  startUnofficialFinal: () =>
    @inUnofficialFinal = true
    @inOfficialFinal =  false
  startOfficialFinal: () =>
    @inUnofficialFinal = false
    @inOfficialFinal =  true
  startTimeout: () =>
    @_stopClocks()
    @jamClock.reset(constants.TIMEOUT_DURATION_IN_MS)
    @jamClock.start()
    @state = "timeout"
    @timeout = null
  setTimeoutAsOfficialTimeout: () =>
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @jamClock.reset(0)
    @jamClock.start()
    @state = "timeout"
    @timeout = "official_timeout"
    @inOfficialTimeout = true
  setTimeoutAsHomeTeamTimeout: () =>
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @state = "timeout"
    @timeout = "home_team_timeout"
    @home.timeouts = @home.timeouts - 1
    @home.isTakingTimeout = true
  setTimeoutAsHomeTeamOfficialReview: () =>
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @jamClock.reset(0)
    @jamClock.start()
    @home.hasOfficialReview = false
    @home.isTakingOfficialReview = true
    @state = "timeout"
    @timeout = "home_team_official_review"
  setTimeoutAsAwayTeamTimeout: () =>
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @state = "timeout"
    @timeout = "away_team_timeout"
    @away.timeouts = @away.timeouts - 1
    @away.isTakingTimeout = true
  setTimeoutAsAwayTeamOfficialReview: () =>
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @jamClock.reset(0)
    @jamClock.start()
    @away.hasOfficialReview = false
    @away.isTakingOfficialReview = true
    @state = "timeout"
    @timeout = "away_team_official_review"
  setJamEndedByTime: () =>
  setJamEndedByCalloff: () =>
  setJamClock: (val) =>
    @jamClock.time = val*1000
  setPeriodClock: (val) =>
    @periodClock.time = val*1000
  setHomeTeamTimeouts: (val) =>
    @home.timeouts = parseInt(val)
  setAwayTeamTimeouts: (val) =>
    @away.timeouts = parseInt(val)
  setPeriodNumber: (val) =>
    @periodNumber = parseInt(val)
  setJamNumber: (val) =>
    @jamNumber = parseInt(val)
  removeHomeTeamOfficialReview: () =>
    @home.hasOfficialReview = false
    @home.officialReviewsRetained = @home.officialReviewsRetained - 1
  removeAwayTeamOfficialReview: () =>
    @away.hasOfficialReview = false
    @away.officialReviewsRetained = @away.officialReviewsRetained - 1
  restoreHomeTeamOfficialReview: () =>
    @home.hasOfficialReview = true
    @_clearTimeouts()
    @home.officialReviewsRetained = @home.officialReviewsRetained + 1
  restoreAwayTeamOfficialReview: (retained = false) =>
    @away.hasOfficialReview = true
    @_clearTimeouts()
    @away.officialReviewsRetained = @away.officialReviewsRetained + 1
  _inTimeout: ()->
      @state == "team_timeout" || @state == "official_timeout"
  _clearAlerts: () =>
    @_clearTimeouts()
    @inUnofficialFinal = false
    @inOfficialFinal = false
    @home.isUnofficialFinal = false
    @home.isOfficialFinal = false
    @away.isUnofficialFinal = false
    @away.isOfficialFinal = false
  _clearTimeouts: () =>
    @home.isTakingTimeout = false
    @away.isTakingTimeout = false
    @home.isTakingOfficialReview = false
    @away.isTakingOfficialReview = false
  _buildOptions: (opts = {}) =>
    std_opts =
      role: 'Jam Timer'
      state: @state
    $.extend(std_opts, opts)
  _stopClocks: () ->
    @jamClock.stop()
    @periodClock.stop()
module.exports = GameState