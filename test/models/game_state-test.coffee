jest.mock '../../app/scripts/models/team'
_ = require 'underscore'
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
DemoData = require '../../app/scripts/demo_data'
{ClockManager, Clock} = require '../../app/scripts/clock'
MemoryStorage = require '../../app/scripts/memory_storage'
describe 'GameState', () ->
  AppDispatcher = undefined
  GameState = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    GameState = require '../../app/scripts/models/game_state'
    GameState.store = new MemoryStorage()
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  it 'initializes with no items', () ->
    games = GameState.all()
    expect(games.length).toBe(0)
  describe "actions", () ->
    gameState = undefined
    beforeEach () ->
      gameState = DemoData.init()
      callback
        type: ActionTypes.SAVE_GAME
        gameState: gameState
    it "saves a new game", () ->
      games = GameState.all()
      expect(games.length).toBe(1)
    it "starts the jam clock", () ->
      gameState = callback
        type: ActionTypes.START_CLOCK
        gameId: gameState.id
      expect(gameState.jamClock.start).toBeCalled()
    it "stops the jam clock", () ->
      gameState = callback
        type: ActionTypes.STOP_CLOCK
        gameId: gameState.id
      expect(gameState.jamClock.stop).toBeCalled()
    describe "starting a new jam", () ->
      beforeEach () ->
        gameState = callback
          type: ActionTypes.START_JAM
          gameId: gameState.id
      it "resets and starts the jam clock", () ->
        expect(gameState.jamClock.reset).toBeCalledWith
          time: constants.JAM_DURATION_IN_MS
          warningTime: constants.JAM_WARNING_IN_MS
        expect(gameState.jamClock.start).toBeCalled()
      it "advances the period and starts the period clock", () ->
        expect(gameState.period).toBe('period 1')
        expect(gameState.periodClock.start).toBeCalled()
        gameState.period = 'halftime'
        gameState.save()
        gameState = callback
          type: ActionTypes.START_JAM
          gameId: gameState.id
        expect(gameState.period).toBe('period 2')
      it "sets the state to jam", () ->
        expect(gameState.state).toBe('jam')
      it "creates new jams", () ->
        expect(gameState.home.createJamsThrough).toBeCalledWith(1)
        expect(gameState.away.createJamsThrough).toBeCalledWith(1)
    it "stops the current jam", () ->
      gameState = callback
        type: ActionTypes.STOP_JAM
        gameId: gameState.id
      expect(gameState.jamClock.stop).toBeCalled()
      expect(gameState.state).toBe('lineup')
    it "starts a new lineup", () ->
      gameState = callback
        type: ActionTypes.START_LINEUP
        gameId: gameState.id
      expect(gameState.state).toBe('lineup')
      expect(gameState.jamClock.reset).toBeCalledWith
        time: constants.LINEUP_DURATION_IN_MS
      expect(gameState.jamClock.start).toBeCalled()
      expect(gameState.period).toBe('pregame')
      expect(gameState.periodClock.start).not.toBeCalled()
    it "starts the pregame", () ->
      gameState = callback
        type: ActionTypes.START_PREGAME
        gameId: gameState.id
      expect(gameState.state).toBe('pregame')
      expect(gameState.period).toBe('pregame')
      expect(gameState.jamClock.reset).toBeCalledWith
        time: constants.PREGAME_DURATION_IN_MS
    it "starts halftime", () ->
      gameState = callback
        type: ActionTypes.START_HALFTIME
        gameId: gameState.id
      expect(gameState.state).toBe('halftime')
      expect(gameState.period).toBe('halftime')
      expect(gameState.jamClock.reset).toBeCalledWith
        time: constants.HALFTIME_DURATION_IN_MS
    it "starts unofficial final", () ->
      gameState = callback
        type: ActionTypes.START_UNOFFICIAL_FINAL
        gameId: gameState.id
      expect(gameState.state).toBe('unofficial final')
      expect(gameState.period).toBe('unofficial final')
    it "starts official final", () ->
      gameState = callback
        type: ActionTypes.START_OFFICIAL_FINAL
        gameId: gameState.id
      expect(gameState.state).toBe('official final')
      expect(gameState.period).toBe('official final')
    it "starts a timeout", () ->
      gameState = callback
        type: ActionTypes.START_TIMEOUT
        gameId: gameState.id
      expect(gameState.state).toBe('timeout')
      expect(gameState.periodClock.stop).toBeCalled()
      expect(gameState.jamClock.reset).toBeCalledWith
        time: 0
        tickUp: true
      expect(gameState.jamClock.start).toBeCalled()
    it "sets a timeout as an official timeout", () ->
      gameState = callback
        type: ActionTypes.SET_TIMEOUT_AS_OFFICIAL_TIMEOUT
        gameId: gameState.id
      expect(gameState.state).toBe('timeout')
      expect(gameState.timeout).toBe('official_timeout')
      expect(gameState.inOfficialTimeout).toBe(true)
    it "sets a timeout as a home team timeout", () ->
      gameState = callback
        type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_TIMEOUT
        gameId: gameState.id
      expect(gameState.state).toBe('timeout')
      expect(gameState.timeout).toBe('home_team_timeout')
      expect(gameState.home.startTimeout).toBeCalled()
    it "sets a timeout as a home team official review", () ->
      gameState = callback
        type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_OFFICIAL_REVIEW
        gameId: gameState.id
      expect(gameState.state).toBe('timeout')
      expect(gameState.timeout).toBe('home_team_official_review')
      expect(gameState.home.isTakingOfficialReview).toBe(true)
      expect(gameState.home.hasOfficialReview).toBe(false)
    it "sets a timeout as an away team timeout", () ->
      gameState = callback
        type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_TIMEOUT
        gameId: gameState.id
      expect(gameState.state).toBe('timeout')
      expect(gameState.timeout).toBe('away_team_timeout')
      expect(gameState.away.startTimeout).toBeCalled()
    it "sets a timeout as an away team official review", () ->
      gameState = callback
        type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_OFFICIAL_REVIEW
        gameId: gameState.id
      expect(gameState.state).toBe('timeout')
      expect(gameState.timeout).toBe('away_team_official_review')
      expect(gameState.away.isTakingOfficialReview).toBe(true)
      expect(gameState.away.hasOfficialReview).toBe(false)
    it "sets the jam clock", () ->
      gameState = callback
        type: ActionTypes.SET_JAM_CLOCK
        gameId: gameState.id
        value: '0:42'
      expect(gameState.jamClock.reset).toBeCalledWith(_.extend(gameState.jamClock, time: '0:42'))
    it "sets the period clock", () ->
      gameState = callback
        type: ActionTypes.SET_PERIOD_CLOCK
        gameId: gameState.id
        value: '0:42'
      expect(gameState.periodClock.reset).toBeCalledWith(_.extend(gameState.periodClock, time: '0:42'))
    it "sets remaining home team timeouts", () ->
      gameState = callback
        type: ActionTypes.SET_HOME_TEAM_TIMEOUTS
        gameId: gameState.id
        value: '2'
      expect(gameState.home.timeouts).toBe(2)
    it "sets remaining away team timeouts", () ->
      gameState = callback
        type: ActionTypes.SET_AWAY_TEAM_TIMEOUTS
        gameId: gameState.id
        value: '2'
      expect(gameState.away.timeouts).toBe(2)
    it "sets the period", () ->
      gameState = callback
        type: ActionTypes.SET_PERIOD
        gameId: gameState.id
        value: 'halftime'
      expect(gameState.period).toBe('halftime')
    it "sets the jam number", () ->
      gameState = callback
        type: ActionTypes.SET_JAM_NUMBER
        gameId: gameState.id
        value: '5'
      expect(gameState.jamNumber).toBe(5)
    it "removes a home team official review", () ->
      gameState = callback
        type: ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
        gameId: gameState.id
      expect(gameState.home.removeOfficialReview).toBeCalled()
    it "removes an away team official review", () ->
      gameState = callback
        type: ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
        gameId: gameState.id
      expect(gameState.away.removeOfficialReview).toBeCalled()
    it "restores a home team official review", () ->
      gameState = callback
        type: ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
        gameId: gameState.id
      expect(gameState.home.restoreOfficialReview).toBeCalled()
    it "restores an away team official review", () ->
      gameState = callback
        type: ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
        gameId: gameState.id
      expect(gameState.away.restoreOfficialReview).toBeCalled()
    it "syncs multiple games", () ->
      gameState = callback
        type: ActionTypes.SYNC_GAMES
        games: "array of gamestates including gameState"


