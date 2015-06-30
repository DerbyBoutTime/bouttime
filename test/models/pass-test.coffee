jest.mock '../../app/scripts/models/skater'
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
describe 'Pass', () ->
  process.setMaxListeners(0)
  AppDispatcher = undefined
  Pass = undefined
  callback = undefined
  beforeEach () ->
    AppDispatcher = require '../../app/scripts/dispatcher/app_dispatcher'
    Pass = require '../../app/scripts/models/pass'
    Pass.store = new MemoryStorage()
    callback = AppDispatcher.register.mock.calls[0][0]
  it 'registers a callback with the dispatcher', () ->
    expect(AppDispatcher.register.mock.calls.length).toBe(1)
  pit 'initializes with no items', () ->
    Pass.all().then (passes) ->
      expect(passes.length).toBe(0)
  describe "actions", () ->
    pass = undefined
    beforeEach () ->
      pass = Pass.new().tap Pass.save
    pit "toggles injury", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.TOGGLE_INJURY
          passId: pass.id
      .then (pass) ->
        expect(pass.injury).toBe(true)
    pit "toggles no pass", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.TOGGLE_NOPASS
          passId: pass.id
      .then (pass) ->
        expect(pass.nopass).toBe(true)
    pit "toggles calloff", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.TOGGLE_CALLOFF
          passId: pass.id
      .then (pass) ->
        expect(pass.calloff).toBe(true)
    pit "toggles lead", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.TOGGLE_LEAD
          passId: pass.id
      .then (pass) ->
        expect(pass.lead).toBe(true)
    pit "toggles lost lead", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.TOGGLE_LOST_LEAD
          passId: pass.id
      .then (pass) ->
        expect(pass.lostLead).toBe(true)
    pit "sets points", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.SET_POINTS
          passId: pass.id
          points: 4
      .then (pass) ->
        expect(pass.points).toBe(4)
    pit "sets the pass jammer", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.SET_PASS_JAMMER
          passId: pass.id
          skaterId: 'skater 1'
      .then (pass) ->
        expect(pass.jammer).toBe('skater 1')
    pit "removes a pass", () ->
      pass.then (pass) ->
        callback
          type: ActionTypes.REMOVE_PASS
          passId: pass.id
      .then () ->
        Pass.all()
      .then (passes) ->
        expect(passes.length).toBe(0)
