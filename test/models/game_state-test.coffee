jest.mock '../../app/scripts/models/team'
jest.mock '../../app/scripts/models/game_metadata'
_ = require 'underscore'
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
DemoData = require '../../app/scripts/demo_data'
{ClockManager, Clock} = require '../../app/scripts/clock'
describe 'GameState', () ->
  process.setMaxListeners(0)
  AppDispatcher = undefined
  GameState = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    GameState = require '../../app/scripts/models/game_state'
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  pit 'initializes with no items', () ->
    GameState.all().then (games) ->
      expect(games.length).toBe(0)
  describe "actions", () ->
    gameState = undefined
    beforeEach () ->
      gameState = DemoData.init().then (gameState) ->
        callback
          type: ActionTypes.SAVE_GAME
          gameState: gameState
    pit "saves a new game", () ->
      gameState.then () ->
        GameState.all()
      .then (games) ->
        expect(games.length).toBe(1)
    pit "starts the jam clock", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.START_CLOCK
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.jamClock.start).toBeCalled()
    pit "stops the jam clock", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.STOP_CLOCK
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.jamClock.stop).toBeCalled()
    describe "starting a new jam", () ->
      beforeEach () ->
        gameState = gameState.then (gameState) ->
          callback
            type: ActionTypes.START_JAM
            gameId: gameState.id
      pit "resets and starts the jam clock", () ->
        gameState.then (gameState) ->
          expect(gameState.jamClock.reset).toBeCalledWith
            time: constants.JAM_DURATION_IN_MS
            warningTime: constants.JAM_WARNING_IN_MS
            isRunning: true
      pit "advances the period and starts the period clock", () ->
        gameState.tap (gameState) ->
          expect(gameState.period).toBe('period 1')
          expect(gameState.periodClock.reset).toBeCalledWith
            time: constants.PERIOD_DURATION_IN_MS
            isRunning: true
        .then (gameState) ->
          callback
            type: ActionTypes.START_JAM
            gameId: gameState.id
        .tap (gameState) ->
          expect(gameState.period).toBe 'period 1'
          expect(gameState.periodClock.start).toBeCalled()
          gameState.period = 'halftime'
          gameState.save()
        .then (gameState) ->
          callback
            type: ActionTypes.START_JAM
            gameId: gameState.id
        .then (gameState) ->
          expect(gameState.period).toBe('period 2')
          expect(gameState.periodClock.reset).toBeCalledWith
            time: constants.PERIOD_DURATION_IN_MS
            isRunning: true
      pit "sets the state to jam", () ->
        gameState.then (gameState) ->
          expect(gameState.state).toBe('jam')
      pit "creates new jams", () ->
        gameState.then (gameState) ->
          expect(gameState.home.createJamsThrough).toBeCalledWith(1)
          expect(gameState.away.createJamsThrough).toBeCalledWith(1)
    pit "stops the current jam", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.STOP_JAM
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('lineup')
    pit "starts a new lineup", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.START_LINEUP
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('lineup')
        expect(gameState.jamClock.reset).toBeCalledWith
          time: constants.LINEUP_DURATION_IN_MS
          isRunning: true
        expect(gameState.period).toBe('pregame')
        expect(gameState.periodClock.start).not.toBeCalled()
    pit "starts the pregame", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.START_PREGAME
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('pregame')
        expect(gameState.period).toBe('pregame')
        expect(gameState.jamClock.reset).toBeCalledWith
          time: constants.PREGAME_DURATION_IN_MS
    pit "starts halftime", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.START_HALFTIME
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('halftime')
        expect(gameState.period).toBe('halftime')
        expect(gameState.jamClock.reset).toBeCalledWith
          time: constants.HALFTIME_DURATION_IN_MS
    pit "starts unofficial final", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.START_UNOFFICIAL_FINAL
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('unofficial final')
        expect(gameState.period).toBe('unofficial final')
    pit "starts official final", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.START_OFFICIAL_FINAL
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('official final')
        expect(gameState.period).toBe('official final')
    pit "starts a timeout", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.START_TIMEOUT
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('timeout')
        expect(gameState.periodClock.stop).toBeCalled()
        expect(gameState.jamClock.reset).toBeCalledWith
          time: 0
          tickUp: true
          isRunning: true
    pit "sets a timeout as an official timeout", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_TIMEOUT_AS_OFFICIAL_TIMEOUT
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('timeout')
        expect(gameState.timeout).toBe('official timeout')
        expect(gameState.inOfficialTimeout).toBe(true)
    pit "sets a timeout as a home team timeout", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_TIMEOUT
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('timeout')
        expect(gameState.timeout).toBe('timeout')
        expect(gameState.home.startTimeout).toBeCalled()
    pit "sets a timeout as a home team official review", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_OFFICIAL_REVIEW
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('timeout')
        expect(gameState.timeout).toBe('official review')
        expect(gameState.home.isTakingOfficialReview).toBe(true)
        expect(gameState.home.hasOfficialReview).toBe(false)
    pit "sets a timeout as an away team timeout", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_TIMEOUT
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('timeout')
        expect(gameState.timeout).toBe('timeout')
        expect(gameState.away.startTimeout).toBeCalled()
    pit "sets a timeout as an away team official review", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_OFFICIAL_REVIEW
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.state).toBe('timeout')
        expect(gameState.timeout).toBe('official review')
        expect(gameState.away.isTakingOfficialReview).toBe(true)
        expect(gameState.away.hasOfficialReview).toBe(false)
    pit "sets the jam clock", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_JAM_CLOCK
          gameId: gameState.id
          value: '0:42'
      .then (gameState) ->
        expect(gameState.jamClock.reset).toBeCalledWith(_.extend(gameState.jamClock, time: '0:42'))
    pit "sets the period clock", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_PERIOD_CLOCK
          gameId: gameState.id
          value: '0:42'
      .then (gameState) ->
        expect(gameState.periodClock.reset).toBeCalledWith(_.extend(gameState.periodClock, time: '0:42'))
    pit "sets remaining home team timeouts", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_HOME_TEAM_TIMEOUTS
          gameId: gameState.id
          value: '2'
      .then (gameState) ->
        expect(gameState.home.timeouts).toBe(2)
    pit "sets remaining away team timeouts", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_AWAY_TEAM_TIMEOUTS
          gameId: gameState.id
          value: '2'
      .then (gameState) ->
        expect(gameState.away.timeouts).toBe(2)
    pit "sets the period", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_PERIOD
          gameId: gameState.id
          value: 'halftime'
      .then (gameState) ->
        expect(gameState.period).toBe('halftime')
    pit "sets the jam number", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.SET_JAM_NUMBER
          gameId: gameState.id
          value: '5'
      .then (gameState) ->
        expect(gameState.jamNumber).toBe(5)
    pit "removes a home team official review", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.home.removeOfficialReview).toBeCalled()
    pit "removes an away team official review", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.away.removeOfficialReview).toBeCalled()
    pit "restores a home team official review", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.home.restoreOfficialReview).toBeCalled()
    pit "restores an away team official review", () ->
      gameState.then (gameState) ->
        callback
          type: ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
          gameId: gameState.id
      .then (gameState) ->
        expect(gameState.away.restoreOfficialReview).toBeCalled()

