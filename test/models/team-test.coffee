jest.mock '../../app/scripts/models/jam'
jest.mock '../../app/scripts/models/skater'
_ = require 'underscore'
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
{ClockManager, Clock} = require '../../app/scripts/clock'
Skater = require '../../app/scripts/models/skater'
describe 'Team', () ->
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
  it 'initializes with no items', () ->
    teams = Team.all()
    expect(teams.length).toBe(0)
  describe "actions", () ->
    team = undefined
    beforeEach () ->
      DemoData = require '../../app/scripts/demo_data'
      team = DemoData.init().home
      team.save()
    it "intializes with a single jame", () ->
      expect(team.jams.length).toBe(1)
    it "creates the next jam", () ->
      team = callback
        type: ActionTypes.CREATE_NEXT_JAM
        teamId: team.id
      expect(team.jams.length).toBe(2)
    describe "penalty box timers", () ->
      beforeEach () ->
        team = callback
          type: ActionTypes.SET_PENALTY_BOX_SKATER
          teamId: team.id
          boxIndexOrPosition: 'jammer'
          clockId: 'clock 1'
          skaterId: 'skater 1'
      it "creates a penalty box state", () ->
        expect(team.penaltyBoxStates.length).toBe(1)
        boxState = team.penaltyBoxStates[0]
        expect(boxState.skater).toBe('skater 1')
      it "sets the skater of an existing box", () ->
        team = callback
          type: ActionTypes.SET_PENALTY_BOX_SKATER
          teamId: team.id
          boxIndexOrPosition: 0
          skaterId: 'skater 2'
        expect(team.penaltyBoxStates.length).toBe(1)
        boxState = team.penaltyBoxStates[0]
        expect(boxState.skater).toBe('skater 2')
      it "toggles left early", () ->
        team = callback
          type: ActionTypes.TOGGLE_LEFT_EARLY
          teamId: team.id
          boxIndex: 0
        boxState = team.penaltyBoxStates[0]
        expect(boxState.leftEarly).toBe(true)
      it "toggles served", () ->
        team = callback
          type: ActionTypes.TOGGLE_PENALTY_SERVED
          teamId: team.id
          boxIndex: 0
        boxState = team.penaltyBoxStates[0]
        expect(boxState.served).toBe(true)
      it "adds penalty time", () ->
        team = callback
          type: ActionTypes.ADD_PENALTY_TIME
          teamId: team.id
          boxIndex: 0
        boxState = team.penaltyBoxStates[0]
        expect(boxState.penaltyCount).toBe(2)
      it "toggles the penalty timer", () ->
        team = callback
          type: ActionTypes.TOGGLE_PENALTY_TIMER
          teamId: team.id
          boxIndex: 0
        boxState = team.penaltyBoxStates[0]
        expect(boxState.clock.start).toBeCalled()
        boxState.clock.isRunning = true
        team.togglePenaltyTimer(0)
        expect(boxState.clock.stop).toBeCalled()
      it "toggles all penalty timers", () ->
        team.setPenaltyBoxSkater('blocker', 'clock 2', 'skater 2')
        team.save()
        team = callback
          type: ActionTypes.TOGGLE_ALL_PENALTY_TIMERS
          teamId: team.id
        expect(team.penaltyBoxStates[0].clock.start).toBeCalled()
        expect(team.penaltyBoxStates[1].clock.start).toBeCalled()
        team.penaltyBoxStates[0].clock.isRunning = true
        team.penaltyBoxStates[1].clock.isRunning = false
        team.penaltyBoxStates[1].clock.start.mockClear()
        team.toggleAllPenaltyTimers()
        expect(team.penaltyBoxStates[0].clock.stop).toBeCalled()
        expect(team.penaltyBoxStates[1].clock.start).not.toBeCalled()
      it "renumbers jams after one is removed", () ->
        team = callback
          type: ActionTypes.REMOVE_JAM
          teamId: team.id
        expect(AppDispatcher.waitFor).toBeCalled()
        expect(team.jams[0].jamNumber).toBe(1)

