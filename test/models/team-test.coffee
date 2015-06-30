jest.mock '../../app/scripts/models/jam'
jest.mock '../../app/scripts/models/skater'
_ = require 'underscore'
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
{ClockManager, Clock} = require '../../app/scripts/clock'
Skater = require '../../app/scripts/models/skater'
describe 'Team', () ->
  process.setMaxListeners(0)
  AppDispatcher = undefined
  Team = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    Team = require '../../app/scripts/models/team'
    Team.store = new MemoryStorage()
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  pit 'initializes with no items', () ->
    Team.all().then (teams) ->
      expect(teams.length).toBe(0)
  describe "actions", () ->
    team = undefined
    beforeEach () ->
      team = Team.new().tap Team.save
    pit "intializes with a single jam", () ->
      team.then (team) ->
        expect(team.jams.length).toBe(1)
    pit "creates the next jam", () ->
      team.then (team) ->
        callback
          type: ActionTypes.CREATE_NEXT_JAM
          teamId: team.id
          jamNumber: 2
      .then (team) ->
        expect(team.jams.length).toBe(2)
    pit "does not create duplicate jams", () ->
      team.then (team) ->
        callback
          type: ActionTypes.CREATE_NEXT_JAM
          teamId: team.id
          jamNumber: 2
      team.then (team) ->
        callback
          type: ActionTypes.CREATE_NEXT_JAM
          teamId: team.id
          jamNumber: 2
      .then (team) ->
        expect(team.jams.length).toBe(2)
    describe "penalty box timers", () ->
      beforeEach () ->
        team = team.then (team) ->
          callback
            type: ActionTypes.SET_PENALTY_BOX_SKATER
            teamId: team.id
            boxIndexOrPosition: 'jammer'
            clockId: 'clock 1'
            skaterId: 'skater 1'
      pit "creates a penalty box state", () ->
        team.then (team) ->
          expect(team.penaltyBoxStates.length).toBe(1)
          boxState = team.penaltyBoxStates[0]
          expect(boxState.skater).toBe('skater 1')
      pit "sets the skater of an existing box", () ->
        team.then (team) ->
          callback
            type: ActionTypes.SET_PENALTY_BOX_SKATER
            teamId: team.id
            boxIndexOrPosition: 0
            skaterId: 'skater 2'
        .then (team) ->
          expect(team.penaltyBoxStates.length).toBe(1)
          boxState = team.penaltyBoxStates[0]
          expect(boxState.skater).toBe('skater 2')
      pit "toggles left early", () ->
        team.then (team) ->
          callback
            type: ActionTypes.TOGGLE_LEFT_EARLY
            teamId: team.id
            boxIndex: 0
        .then (team) ->
          boxState = team.penaltyBoxStates[0]
          expect(boxState.leftEarly).toBe(true)
      pit "toggles served", () ->
        team.then (team) ->
          callback
            type: ActionTypes.TOGGLE_PENALTY_SERVED
            teamId: team.id
            boxIndex: 0
        .then (team) ->
          boxState = team.penaltyBoxStates[0]
          expect(boxState.served).toBe(true)
      pit "adds penalty time", () ->
        team.then (team) ->
          callback
            type: ActionTypes.ADD_PENALTY_TIME
            teamId: team.id
            boxIndex: 0
        .then (team) ->
          boxState = team.penaltyBoxStates[0]
          expect(boxState.penaltyCount).toBe(2)
      pit "toggles the penalty timer", () ->
        team.then (team) ->
          callback
            type: ActionTypes.TOGGLE_PENALTY_TIMER
            teamId: team.id
            boxIndex: 0
        .then (team) ->
          boxState = team.penaltyBoxStates[0]
          expect(boxState.clock.start).toBeCalled()
          boxState.clock.isRunning = true
          team.togglePenaltyTimer(0)
          expect(boxState.clock.stop).toBeCalled()
      pit "toggles all penalty timers", () ->
        team.tap (team) ->
          team.setPenaltyBoxSkater('blocker', 'clock 2', 'skater 2')
        .tap Team.save
        .then (team) ->
          callback
            type: ActionTypes.TOGGLE_ALL_PENALTY_TIMERS
            teamId: team.id
        .then (team) ->
          expect(team.penaltyBoxStates[0].clock.start).toBeCalled()
          expect(team.penaltyBoxStates[1].clock.start).toBeCalled()
          team.penaltyBoxStates[0].clock.isRunning = true
          team.penaltyBoxStates[1].clock.isRunning = false
          team.penaltyBoxStates[1].clock.start.mockClear()
          team.toggleAllPenaltyTimers()
          expect(team.penaltyBoxStates[0].clock.stop).toBeCalled()
          expect(team.penaltyBoxStates[1].clock.start).not.toBeCalled()
      pit "renumbers jams after one is removed", () ->
        team.then (team) ->
          callback
            type: ActionTypes.REMOVE_JAM
            teamId: team.id
        .then (team) ->
          expect(AppDispatcher.waitFor).toBeCalled()
          expect(team.jams[0].jamNumber).toBe(1)

