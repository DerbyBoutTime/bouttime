jest.mock '../../app/scripts/models/skater'
{ActionTypes} = require '../../app/scripts/constants'
describe 'BoxEntry', () ->
  process.setMaxListeners(0)
  AppDispatcher = undefined
  BoxEntry = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    BoxEntry = require '../../app/scripts/models/box_entry'
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  pit 'initializes with no items', () ->
    BoxEntry.all().then (boxes) ->
      expect(boxes.length).toBe(0)
  describe "actions", () ->
    box = undefined
    beforeEach () ->
      box = BoxEntry.new().tap BoxEntry.save
    pit "sets the box skater", () ->
      box.then (box) ->
        callback
          type: ActionTypes.SET_PENALTY_BOX_SKATER
          boxId: box.id
          skaterId: 'skater 2'
      .then (box) ->
        expect(box.skater.id).toBe('skater 2')
    pit "toggles left early", () ->
      box.then (box) ->
        callback
          type: ActionTypes.TOGGLE_LEFT_EARLY
          boxId: box.id
      .then (box) ->
        expect(box.leftEarly).toBe(true)
    pit "toggles served", () ->
      box.then (box) ->
        callback
          type: ActionTypes.TOGGLE_PENALTY_SERVED
          boxId: box.id
      .then (box) ->
        expect(box.served).toBe(true)
    pit "toggles the penalty timer", () ->
      box.then (box) ->
        callback
          type: ActionTypes.TOGGLE_PENALTY_TIMER
          boxId: box.id
      .then (box) ->
        expect(box.clock.toggle).toBeCalled()