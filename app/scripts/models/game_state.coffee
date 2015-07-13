moment = require 'moment'
$ = require 'jquery'
_ = require 'underscore'
functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
Store = require './store'
{ClockManager} = require '../clock'
Team = require './team'
GameMetadata = require './game_metadata'
{ActionTypes} = require '../constants'
constants = require '../constants'
PERIOD_CLOCK_SETTINGS =
  time: constants.PERIOD_DURATION_IN_MS
PREGAME_CLOCK_SETTINGS =
  time: constants.PREGAME_DURATION_IN_MS
HALFTIME_CLOCK_SETTINGS =
  time: constants.HALFTIME_DURATION_IN_MS
JAM_CLOCK_SETTINGS =
  time: constants.JAM_DURATION_IN_MS
  warningTime: constants.JAM_WARNING_IN_MS
  isRunning: true
LINEUP_CLOCK_SETTINGS =
  time: constants.LINEUP_DURATION_IN_MS
  isRunning: true
TIMEOUT_CLOCK_SETTINGS =
  time: 0
  tickUp: true
  isRunning: true
class GameState extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    game = @find(action.gameId)
    switch action.type
      when ActionTypes.START_CLOCK
        game.startClock()
        game.syncClocks(action)
      when ActionTypes.STOP_CLOCK
        game.stopClock()
        game.syncClocks(action)
      when ActionTypes.START_JAM
        game.startJam()
        game.syncClocks(action)
      when ActionTypes.STOP_JAM
        game.stopJam()
        game.syncClocks(action)
      when ActionTypes.START_LINEUP
        game.startLineup()
        game.syncClocks(action)
      when ActionTypes.START_PREGAME
        game.startPregame()
        game.syncClocks(action)
      when ActionTypes.START_HALFTIME
        game.startHalftime()
        game.syncClocks(action)
      when ActionTypes.START_UNOFFICIAL_FINAL
        game.startUnofficialFinal()
        game.syncClocks(action)
      when ActionTypes.START_OFFICIAL_FINAL
        game.startOfficialFinal()
        game.syncClocks(action)
      when ActionTypes.START_TIMEOUT
        game.startTimeout()
        game.syncClocks(action)
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
      when ActionTypes.HANDLE_CLOCK_EXPIRATION
        game.handleClockExpiration()
      when ActionTypes.SET_JAM_CLOCK
        game.setJamClock(action.value)
      when ActionTypes.SET_PERIOD_CLOCK
        game.setPeriodClock(action.value)
      when ActionTypes.SET_HOME_TEAM_TIMEOUTS
        game.setHomeTeamTimeouts(action.value)
      when ActionTypes.SET_AWAY_TEAM_TIMEOUTS
        game.setAwayTeamTimeouts(action.value)
      when ActionTypes.SET_PERIOD
        game.setPeriod(action.value)
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
      when ActionTypes.JAM_TIMER_UNDO
        game.undo()
      when ActionTypes.JAM_TIMER_REDO
        game.redo()
      when ActionTypes.SAVE_GAME
        game = new GameState(action.gameState)
        game.syncClocks(action.gameState)
    game.save() if game?
    @emitChange()
    #return instance operated on for testing
    game
  constructor: (options={}) ->
    super options
    @name = options.name
    @venue = options.venue
    @date = options.date
    @time = options.time
    @officials = options.officials ? []
    @debug = options.debug ? false
    @state = options.state ? 'pregame'
    @period = options.period ? 'pregame'
    @jamNumber = options.jamNumber ? 0
    @clockManager = new ClockManager()
    @jamClock = @clockManager.getOrAddClock "jamClock-#{@id}", options.jamClock ? PREGAME_CLOCK_SETTINGS
    @periodClock = @clockManager.getOrAddClock "periodClock-#{@id}", options.periodClock ? PERIOD_CLOCK_SETTINGS
    @home = Team.find(options.home?.id) ? new Team(options.home)
    @away = Team.find(options.away?.id) ? new Team(options.away)
    @timeout = options.timeout ? null
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
    @_undoStack = options._undoStack ? []
    @_redoStack = options._redoStack ? []
  save: () ->
    super()
    @home.save()
    @away.save()
  getDisplayName: () ->
    "#{moment(@date, 'MM/DD/YYYY').format('YYYY-MM-DD')} #{@home.name} vs #{@away.name}"
  getCurrentJam: (team) ->
    (jam for jam in team.jams when jam.jamNumber is @jamNumber)[0]
  syncClocks: (clocks) ->
    @jamClock.sync(clocks.jamClock)
    @periodClock.sync(clocks.periodClock)
    if clocks.sourceDelay? and clocks.destinationDelay?
      delta = (clocks.sourceDelay + clocks.destinationDelay) / 2.0
      @jamClock.tick(delta)
      @periodClock.tick(delta)
  startClock: ()->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.start()
  stopClock: () ->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.stop()
  advancePeriod: () ->
    if @period is "pregame"
      @period = "period 1"
      @periodClock.reset(PERIOD_CLOCK_SETTINGS)
    else if @period is "halftime"
      @period = "period 2"
      @periodClock.reset(PERIOD_CLOCK_SETTINGS)
    else
      #Dummy reset
      @periodClock.reset()
  startJam: () ->
    @_clearTimeouts()
    @_pushUndo()
    @jamClock.reset(JAM_CLOCK_SETTINGS)
    @advancePeriod()
    @state = "jam"
    @jamNumber = @jamNumber + 1
    @home.createJamsThrough @jamNumber
    @away.createJamsThrough @jamNumber
  stopJam: () ->
    @startLineup()
  startLineup: () ->
    @_clearTimeouts()
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.reset(LINEUP_CLOCK_SETTINGS)
    @state = "lineup"
  startPregame: () ->
    @_pushUndo()
    @periodClock.reset(time: 0)
    @jamClock.reset(PREGAME_CLOCK_SETTINGS)
    @state = "pregame"
    @period = "pregame"
  startHalftime: () ->
    @_pushUndo()
    @periodClock.reset(time: 0)
    @jamClock.reset(HALFTIME_CLOCK_SETTINGS)
    @state = "halftime"
    @period = "halftime"
  startUnofficialFinal: () ->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.reset() #Dummy reset
    @state = "unofficial final"
    @period = "unofficial final"
  startOfficialFinal: () ->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.reset() #Dummy reset
    @state = "official final"
    @period = "official final"
  startTimeout: () ->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.reset(TIMEOUT_CLOCK_SETTINGS)
    @state = "timeout"
    @timeout = null
  setTimeoutAsOfficialTimeout: () ->
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @_clearUndo()
    @timeout = "official_timeout"
    @inOfficialTimeout = true
  setTimeoutAsHomeTeamTimeout: () ->
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @_clearUndo()
    @timeout = "home_team_timeout"
    @home.startTimeout()
  setTimeoutAsHomeTeamOfficialReview: () ->
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @_clearUndo()
    @home.hasOfficialReview = false
    @home.isTakingOfficialReview = true
    @timeout = "home_team_official_review"
  setTimeoutAsAwayTeamTimeout: () ->
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @_clearUndo()
    @state = "timeout"
    @timeout = "away_team_timeout"
    @away.startTimeout()
  setTimeoutAsAwayTeamOfficialReview: () ->
    if @_inTimeout() == false
      @startTimeout()
    @_clearTimeouts()
    @_clearUndo()
    @away.hasOfficialReview = false
    @away.isTakingOfficialReview = true
    @state = "timeout"
    @timeout = "away_team_official_review"
  handleClockExpiration: () ->
    if @state == "jam"
      #Mark as jam ended by time
      @stopJam()
  setJamClock: (val) ->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.reset(_.extend(@jamClock, time: val))
  setPeriodClock: (val) ->
    @_pushUndo()
    @jamClock.reset() #Dummy reset
    @periodClock.reset(_.extend(@periodClock, time: val))
  setHomeTeamTimeouts: (val) ->
    @home.timeouts = parseInt(val)
  setAwayTeamTimeouts: (val) ->
    @away.timeouts = parseInt(val)
  setPeriod: (val) ->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.reset() #Dummy reset
    @period = val
  setJamNumber: (val) ->
    @_pushUndo()
    @periodClock.reset() #Dummy reset
    @jamClock.reset() #Dummy reset
    @jamNumber = parseInt(val)
  removeHomeTeamOfficialReview: () ->
    @home.removeOfficialReview()
  removeAwayTeamOfficialReview: () ->
    @away.removeOfficialReview()
  restoreHomeTeamOfficialReview: () ->
    @_clearTimeouts()
    @home.restoreOfficialReview()
  restoreAwayTeamOfficialReview: () ->
    @_clearTimeouts()
    @away.restoreOfficialReview()
  getMetadata: () ->
    new GameMetadata
      id: @id
      display: @getDisplayName()
  undo: () ->
    @_popUndo()
    @jamClock.undo()
    @periodClock.undo()
  redo: () ->
    @_popRedo()
    @jamClock.redo()
    @periodClock.redo()
  isUndoable: () ->
    @_undoStack.length > 0 and @jamClock.isUndoable() and @periodClock.isUndoable()
  isRedoable: () ->
    @_redoStack.length > 0 and @jamClock.isRedoable() and @periodClock.isRedoable()
  _inTimeout: ()->
      @state == "timeout"
  _clearAlerts: () ->
    @_clearTimeouts()
  _clearTimeouts: () ->
    @home.isTakingTimeout = false
    @away.isTakingTimeout = false
    @home.isTakingOfficialReview = false
    @away.isTakingOfficialReview = false
  _historyFrame: () ->
    state: @state
    period: @period
    jamNumber: @jamNumber
  _pushFrame: (stack) ->
    stack.push @_historyFrame()
  _popFrame: (stack) ->
    for key, value of stack.pop()
      @[key] = value
  _pushUndo: () ->
    @_clearRedo()
    @_pushFrame @_undoStack
  _popUndo: () ->
    @_pushRedo()
    @_popFrame @_undoStack
  _clearUndo: () ->
    @_clearRedo()
    @_undoStack = []
    @jamClock.clearUndo()
    @periodClock.clearUndo()
  _pushRedo: () ->
    @_pushFrame @_redoStack
  _popRedo: () ->
    @_pushFrame @_undoStack
    @_popFrame @_redoStack
  _clearRedo: () ->
    @_redoStack = []
    @jamClock.clearRedo()
    @periodClock.clearRedo()
module.exports = GameState
