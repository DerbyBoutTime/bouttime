constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
describe 'Skater', () ->
  process.setMaxListeners(0)
  AppDispatcher = undefined
  Skater = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    Skater = require '../../app/scripts/models/skater'
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  pit 'initializes with no items', () ->
    Skater.all().then (skaters) ->
      expect(skaters.length).toBe(0)
  describe "actions", () ->
    skater = undefined
    beforeEach () ->
      skater = Skater.new(name: 'Test Cancer', number: '42')
      .tap Skater.save
    describe "penalties", () ->
      beforeEach () ->
        skater = skater.then (skater) ->
          callback
            type: ActionTypes.SET_PENALTY
            skaterId: skater.id
            jamNumber: 1
            penalty: {foo: 'bar'}
      pit "creates a new penalty", () ->
        skater.then (skater) ->
          expect(skater.penalties.length).toBe(1)
          expect(skater.penalties[0]).toEqual
            jamNumber: 1
            penalty: {foo: 'bar'}
      pit "updates a penalty", () ->
        skater.then (skater) ->
          callback
            type: ActionTypes.UPDATE_PENALTY
            skaterId: skater.id
            skaterPenaltyIndex: 0
            opts:
              jamNumber: 2
              penalty:
                foo: 'baz'
        .then (skater) ->
          expect(skater.penalties[0]).toEqual
            jamNumber: 2
            penalty:
              foo: 'baz'
      pit "clears a penalty", () ->
        skater.then (skater) ->
          callback
            type: ActionTypes.CLEAR_PENALTY
            skaterId: skater.id
            skaterPenaltyIndex: 0
        .then (skater) ->
          expect(skater.penalties.length).toBe(0)


