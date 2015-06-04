constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
describe 'Skater', () ->
  AppDispatcher = undefined
  Skater = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    Skater = require '../../app/scripts/models/skater'
    Skater.store = new MemoryStorage()
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  it 'initializes with no items', () ->
    skaters = Skater.all()
    expect(skaters.length).toBe(0)
  describe "actions", () ->
    skater = undefined
    beforeEach () ->
      skater = new Skater(name: 'Test Cancer', number: '42')
      skater.save()
    describe "penalties", () ->
      beforeEach () ->
        skater = callback
          type: ActionTypes.SET_PENALTY
          skaterId: skater.id
          jamNumber: 1
          penalty: {foo: 'bar'}
      it "creates a new penalty", () ->
        expect(skater.penalties.length).toBe(1)
        expect(skater.penalties[0]).toEqual
          jamNumber: 1
          penalty: {foo: 'bar'}
      it "updates a penalty", () ->
        skater = callback
          type: ActionTypes.UPDATE_PENALTY
          skaterId: skater.id
          skaterPenaltyIndex: 0
          opts:
            jamNumber: 2
            penalty:
              foo: 'baz'
        expect(skater.penalties[0]).toEqual
          jamNumber: 2
          penalty:
            foo: 'baz'
      it "clears a penalty", () ->
        skater = callback
          type: ActionTypes.CLEAR_PENALTY
          skaterId: skater.id
          skaterPenaltyIndex: 0
        expect(skater.penalties.length).toBe(0)


