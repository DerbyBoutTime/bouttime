moment = require 'moment'
$ = require 'jquery'
_ = require 'underscore'
Promise = require 'bluebird'
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
  isRunning: true
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
    switch action.type
      when ActionTypes.START_CLOCK
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.startClock()
          game.save()
      when ActionTypes.STOP_CLOCK
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.stopClock()
          game.save()
      when ActionTypes.START_JAM
        @find(action.gameId).tap (game) ->
          game.syncClocks(action)
          game.startJam()
        .tap (game) ->
          Promise.join game.save(), game.home.save(), game.away.save()
      when ActionTypes.STOP_JAM
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.stopJam()
          game.save()
      when ActionTypes.START_LINEUP
        @find(action.gameId).tap (game) ->
          game.syncClocks(action)
          game.startLineup()
          Promise.join game.save(), game.home.save(), game.away.save()
      when ActionTypes.START_PREGAME
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.startPregame()
          game.save()
      when ActionTypes.START_HALFTIME
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.startHalftime()
          game.save()
      when ActionTypes.START_UNOFFICIAL_FINAL
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.startUnofficialFinal()
          game.save()
      when ActionTypes.START_OFFICIAL_FINAL
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.startOfficialFinal()
          game.save()
      when ActionTypes.START_TIMEOUT
        @find(action.gameId).then (game) ->
          game.syncClocks(action)
          game.startTimeout()
          game.save()
      when ActionTypes.SET_TIMEOUT_AS_OFFICIAL_TIMEOUT
        @find(action.gameId).tap (game) ->
          game.setTimeoutAsOfficialTimeout()
          Promise.join(game.save(), game.home.save(), game.away.save())
      when ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_TIMEOUT
        @find(action.gameId).tap (game) ->
          game.setTimeoutAsHomeTeamTimeout()
          Promise.join(game.save(), game.home.save(), game.away.save())
      when ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_OFFICIAL_REVIEW
        @find(action.gameId).tap (game) ->
          game.setTimeoutAsHomeTeamOfficialReview()
          Promise.join(game.save(), game.home.save(), game.away.save())
      when ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_TIMEOUT
        @find(action.gameId).tap (game) ->
          game.setTimeoutAsAwayTeamTimeout()
          Promise.join(game.save(), game.home.save(), game.away.save())
      when ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_OFFICIAL_REVIEW
        @find(action.gameId).tap (game) ->
          game.setTimeoutAsAwayTeamOfficialReview()
          Promise.join(game.save(), game.home.save(), game.away.save())
      when ActionTypes.SET_JAM_ENDED_BY_TIME
        @find(action.gameId).then (game) ->
          game.setJamEndedByTime()
          game.save()
      when ActionTypes.HANDLE_CLOCK_EXPIRATION
        @find(action.gameId).then (game) ->
          game.handleClockExpiration()
          game.save()
      when ActionTypes.SET_JAM_CLOCK
        @find(action.gameId).then (game) ->
          game.setJamClock(action.value)
          game.save()
      when ActionTypes.SET_PERIOD_CLOCK
        @find(action.gameId).then (game) ->
          game.setPeriodClock(action.value)
          game.save()
      when ActionTypes.SET_HOME_TEAM_TIMEOUTS
        @find(action.gameId).tap (game) ->
          game.setHomeTeamTimeouts(action.value)
          Promise.join game.save(), game.home.save()
      when ActionTypes.SET_AWAY_TEAM_TIMEOUTS
        @find(action.gameId).tap (game) ->
          game.setAwayTeamTimeouts(action.value)
          Promise.join game.save(), game.away.save()
      when ActionTypes.SET_PERIOD
        @find(action.gameId).then (game) ->
          game.setPeriod(action.value)
          game.save()
      when ActionTypes.SET_JAM_NUMBER
        @find(action.gameId).then (game) ->
          game.setJamNumber(action.value)
          game.save()
      when ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
        @find(action.gameId).tap (game) ->
          game.removeHomeTeamOfficialReview()
          Promise.join game.save(), game.home.save()
      when ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
        @find(action.gameId).tap (game) ->
          game.removeAwayTeamOfficialReview()
          Promise.join game.save(), game.away.save()
      when ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
        @find(action.gameId).tap (game) ->
          game.restoreHomeTeamOfficialReview()
          Promise.join game.save(), game.home.save()
      when ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
        @find(action.gameId).tap (game) ->
          game.restoreAwayTeamOfficialReview()
          Promise.join game.save(), game.away.save()
      when ActionTypes.JAM_TIMER_UNDO
        @find(action.gameId).tap (game) ->
          game.undo()
          game.save()
      when ActionTypes.JAM_TIMER_REDO
        @find(action.gameId).tap (game) ->
          game.redo()
          game.save()
      when ActionTypes.SAVE_GAME
        @new(action.gameState).then (game) ->
          game.syncClocks(action.gameState)
          game.save(true)
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
    @timeout = options.timeout ? null
    @home = options.home
    @away = options.away
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
  load: (options={}) ->
    home = Team.findOrCreate(@home).then (home) =>
      @home = home
    away = Team.findOrCreate(@away).then (away) =>
      @away = away    
    Promise.join(home, away).return(this)
  save: (cascade=false) ->
    promise = super()
    if cascade
      promise = promise.then () =>
        Promise.join(@home.save(true), @away.save(true))
      .return this
    promise
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
      @periodClock.start()
  startJam: () ->
    @_clearTimeouts()
    @_pushUndo()
    @jamClock.reset(JAM_CLOCK_SETTINGS)
    @advancePeriod()
    @state = "jam"
    @jamNumber = @jamNumber + 1
    home = @home.createJamsThrough(@jamNumber)
    away = @away.createJamsThrough(@jamNumber)
    Promise.join home, away
  stopJam: () =>
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
    @periodClock.stop()
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
