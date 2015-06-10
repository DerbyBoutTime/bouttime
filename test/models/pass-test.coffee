jest.mock '../../app/scripts/models/skater'
constants = require '../../app/scripts/constants'
ActionTypes = constants.ActionTypes
MemoryStorage = require '../../app/scripts/memory_storage'
describe 'Pass', () ->
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
  it 'initializes with no items', () ->
    passes = Pass.all()
    expect(passes.length).toBe(0)
  describe "actions", () ->
    pass = undefined
    beforeEach () ->
      pass = new Pass()
      pass.save()
    it "toggles injury", () ->
      pass = callback
        type: ActionTypes.TOGGLE_INJURY
        passId: pass.id
      expect(pass.injury).toBe(true)
    it "toggles no pass", () ->
      pass = callback
        type: ActionTypes.TOGGLE_NOPASS
        passId: pass.id
      expect(pass.nopass).toBe(true)
    it "toggles calloff", () ->
      pass = callback
        type: ActionTypes.TOGGLE_CALLOFF
        passId: pass.id
      expect(pass.calloff).toBe(true)
    it "toggles lead", () ->
      pass = callback
        type: ActionTypes.TOGGLE_LEAD
        passId: pass.id
      expect(pass.lead).toBe(true)
    it "toggles lost lead", () ->
      pass = callback
        type: ActionTypes.TOGGLE_LOST_LEAD
        passId: pass.id
      expect(pass.lostLead).toBe(true)
    it "sets points", () ->
      pass = callback
        type: ActionTypes.SET_POINTS
        passId: pass.id
        points: 4
      expect(pass.points).toBe(4)
    it "sets the pass jammer", () ->
      pass = callback
        type: ActionTypes.SET_PASS_JAMMER
        passId: pass.id
        skaterId: 'skater 1'
      expect(pass.jammer).toBe('skater 1')