jest.mock '../../app/scripts/models/jam'
jest.mock '../../app/scripts/models/skater'
jest.mock '../../app/scripts/models/box_entry'
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
  Jam = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    Jam = require '../../app/scripts/models/jam'
    Team = require '../../app/scripts/models/team'
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
    pit "renumbers jams after one is removed", () ->
      team.then (team) ->
        Jam.dispatchToken = teamId: team.id
        callback
          type: ActionTypes.REMOVE_JAM
      .then (team) ->
        expect(AppDispatcher.waitFor).toBeCalled()
        expect(team.jams[0].jamNumber).toBe(1)
        expect(team.jams[0].save).toBeCalled()
    pit "toggles all penalty timers", () ->
      team.then (team) ->
        callback
          type: ActionTypes.TOGGLE_ALL_PENALTY_TIMERS
          teamId: team.id
      .then (team) ->
        for seat in team.seats
          expect(seat.startPenaltyTimer).toBeCalled()
        team.seats[0].penaltyTimerIsRunning.mockReturnValueOnce true
        team.toggleAllPenaltyTimers()
        for seat in team.seats
          expect(seat.stopPenaltyTimer).toBeCalled()

