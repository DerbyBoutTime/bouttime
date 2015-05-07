functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
Store = require './store'
Clocks = require '../clock'
Team = require './team'
{ActionTypes} = require '../constants'
constants = require '../constants'
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
        game.setJamClock(action.value)
      when ActionTypes.SET_PERIOD_CLOCK
        game.setPeriodClock(action.value)
      when ActionTypes.SET_HOME_TEAM_TIMEOUTS
        game.setHomeTeamTimeouts(action.value)
      when ActionTypes.SET_AWAY_TEAM_TIMEOUTS
        game.setAwayTeamTimeouts(action.value)
      when ActionTypes.SET_PERIOD_NUMBER
        game.setPeriodNumber(action.value)
      when ActionTypes.SET_JAM_NUMBER
        game.setJamNumber(action.value)
      when ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
        game.removeHomeTeamOfficialReview()
      when ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
        game.removeAwayTeamOfficialReview()
      when ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
        game.restoreHomeTeamOfficialReview()
      when ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
        game.restoreAwayTeamOfficialReview()
      when ActionTypes.SAVE_GAME
        game = GameState.deserialize(action.gameState)
      when ActionTypes.SYNC_GAMES
        GameState.deserialize(obj).save() for obj in action.games
    game.save() if game?
    @emitChange()
  @deserialize: (obj) ->
    game = new GameState(obj)
    game.id = obj.id
    game.home = Team.deserialize(obj.home)
    game.away = Team.deserialize(obj.away)
    game
  constructor: (options={}) ->
    super options
    @name = options.name
    @venue = options.venue
    @date = options.date
    @time = options.time
    @officials = options.officials || []
    @debug = options.debug || false
    @state = options.state || 'pregame'
    @jamNumber = options.jamNumber || 0
    @periodNumber = options.periodNumber || 0
    console.log(options)
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
    @jamClock.emitter.on "clockExpiration", (evt) =>
      @handleClockExpiration(evt)
    @periodClock = @clockManager.getClock("periodClock")
    @home = options.home || new Team()
    @away = options.away || new Team()
    @penalties = [
      {code: "A", name: "High Block"},
      {code: "N", name: "Insubordination"},
      {code: "B", name: "Back Block"},
      {code: "S", name: "Skating Out of Bnds."},
      {code: "E", name: "Elbows"},
      {code: "X", name: "Cutting the Track"},
      {code: "F", name: "Forearms"},
      {code: "Z", name: "Delay of Game"},
      {code: "G", name: "Misconduct"},
      {code: "C", name: "Dir. of Game Play"},
      {code: "H", name: "Blocking with Head"},
      {code: "O", name: "Out of Bounds"},
      {code: "L", name: "Low Block"},
      {code: "P", name: "Out of Play"},
      {code: "M", name: "Multi-Player Block"},
      {code: "I", name: "Illegal Procedure"},
      {code: "G", name: "Gross Misconduct"}
    ]
  handleClockExpiration: (evt) ->
    if @state == "jam"
      @stopJam()
  save: () ->
    super()
    @home.save()
    @away.save()
  getDisplayName: () ->
    "#{moment(@date, 'MM/DD/YYYY').format('YYYY-MM-DD')} #{@home.name} vs #{@away.name}"
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
    if @periodNumber == 0 || @periodClock.time == 0
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
    @jamClock.reset(val*1000)
  setPeriodClock: (val) =>
    @periodClock.reset(val*1000)
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
