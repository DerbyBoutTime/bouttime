jest.mock('../../app/scripts/models/pass')
jest.mock('../../app/scripts/models/skater')
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
Pass = require '../../app/scripts/models/pass'
describe 'Jam', () ->
  AppDispatcher = undefined
  Jam = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    Jam = require '../../app/scripts/models/jam'
    Jam.store = new MemoryStorage()
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  it 'initializes with no items', () ->
    jams = Jam.all()
    expect(jams.length).toBe(0)
  describe "actions", () ->
    jam = undefined
    beforeEach () ->
      jam = callback
        type: ActionTypes.SAVE_JAM
    it "saves a new jam", () ->
      expect(Jam.all().length).toBe(1)
    it "toggles no pivot", () ->
      jam = callback
        type: ActionTypes.TOGGLE_NO_PIVOT
        jamId: jam.id
      expect(jam.noPivot).toBe(true)
    it "toggles star pass", () ->
      jam = callback
        type: ActionTypes.TOGGLE_STAR_PASS
        jamId: jam.id
      expect(jam.starPass).toBe(true)
    it "sets a star pass for a specific pass", () ->
      jam = callback
        type: ActionTypes.SET_STAR_PASS
        passId:
          jamId: jam.id
          passNumber: 1
      expect(jam.starPass).toBe(true)
      expect(jam.starPassNumber).toBe(1)
      expect(jam.passes.length).toBe(1)
    it "sets a skater to a position", () ->
      jam = callback
        type: ActionTypes.SET_SKATER_POSITION
        jamId: jam.id
        position: 'blocker2'
        skaterId: 'skater 1'
      expect(jam.blocker2).toBe('skater 1')
    it "cycles a lineup status", () ->
      jam = callback
        type: ActionTypes.CYCLE_LINEUP_STATUS
        jamId: jam.id
        statusIndex: 0
        position: 'pivot'
      expect(jam.lineupStatuses[0]['pivot']).toBe('went_to_box')
    it "reorders passes", () ->
      spyOn(Jam.prototype, 'reorderPass')
      jam = callback
        type: ActionTypes.REORDER_PASS
        jamId: jam.id
        sourcePassIndex: 0
        targetPassIndex: 1
      expect(jam.reorderPass).toHaveBeenCalledWith(0, 1)
    it "creates a new pass", () ->
      jam = callback
        type: ActionTypes.CREATE_NEXT_PASS
        jamId: jam.id
        passId: 'pass 2'
      expect(jam.passes.length).toBe(2)
    it "renumbers passes after one is removed", () ->
      jam = callback
        type: ActionTypes.REMOVE_PASS
        jamId: jam.id
      expect(AppDispatcher.waitFor).toBeCalled()
      expect(jam.passes[0].passNumber).toBe(1)
    it "removes a jam", () ->
      jam = callback
        type: ActionTypes.REMOVE_JAM
        jamId: jam.id
      expect(Jam.all().length).toBe(0)