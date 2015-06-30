jest.mock('../../app/scripts/models/pass')
jest.mock('../../app/scripts/models/skater')
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
Pass = require '../../app/scripts/models/pass'
describe 'Jam', () ->
  process.setMaxListeners(0)
  AppDispatcher = undefined
  Jam = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    Jam = require '../../app/scripts/models/jam'
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  pit 'initializes with no items', () ->
    Jam.all().then (jams) ->
      expect(jams.length).toBe(0)
  describe "actions", () ->
    jam = undefined
    beforeEach () ->
      jam = Jam.new().tap Jam.save
    pit "saves a new jam", () ->
      jam.then (jam) ->
        Jam.all()
      .then (jams) ->
        expect(jams.length).toBe(1)
    pit "toggles no pivot", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.TOGGLE_NO_PIVOT
          jamId: jam.id
      .then (jam) ->
        expect(jam.noPivot).toBe(true)
    pit "toggles star pass", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.TOGGLE_STAR_PASS
          jamId: jam.id
      .then (jam) ->
        expect(jam.starPass).toBe(true)
    pit "sets a star pass for a specific pass", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.SET_STAR_PASS
          passId:
            jamId: jam.id
            passNumber: 1
      .then (jam) ->
        expect(jam.starPass).toBe(true)
        expect(jam.starPassNumber).toBe(1)
        expect(jam.passes.length).toBe(1)
    pit "sets a skater to a position", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.SET_SKATER_POSITION
          jamId: jam.id
          position: 'blocker2'
          skaterId: 'skater 1'
      .then (jam) ->
        expect(jam.blocker2).toBe('skater 1')
    pit "cycles a lineup status", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.CYCLE_LINEUP_STATUS
          jamId: jam.id
          statusIndex: 0
          position: 'pivot'
      .then (jam) ->
        expect(jam.lineupStatuses[0]['pivot']).toBe('went_to_box')
    pit "reorders passes", () ->
      spyOn(Jam.prototype, 'reorderPass')
      jam.then (jam) ->
        callback
          type: ActionTypes.REORDER_PASS
          jamId: jam.id
          sourcePassIndex: 0
          targetPassIndex: 1
      .then (jam) ->
        expect(jam.reorderPass).toHaveBeenCalledWith(0, 1)
    pit "creates a new pass", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.CREATE_NEXT_PASS
          jamId: jam.id
          passNumber: 2
      .then (jam) ->
        expect(jam.passes.length).toBe(2)
    pit "renumbers passes after one is removed", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.REMOVE_PASS
          jamId: jam.id
      .then (jam) ->
        expect(AppDispatcher.waitFor).toBeCalled()
        expect(jam.passes[0].passNumber).toBe(1)
    pit "removes a jam", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.REMOVE_JAM
          jamId: jam.id
      .then () ->
        Jam.all()
      .then (jams) ->
        expect(jams.length).toBe(0)
    pit "does not create duplicate passes", () ->
      jam.then (jam) ->
        callback
          type: ActionTypes.CREATE_NEXT_PASS
          jamId: jam.id
          passNumber: 2
      .then (jam) ->
        callback
          type: ActionTypes.CREATE_NEXT_PASS
          jamId: jam.id
          passNumber: 2
      .then (jam) ->
        expect(jam.passes.length).toBe(2)
