AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
{ClockManager} = require '../clock'
Store = require './store'
Skater = require './skater'
PENALTY_CLOCK_SETTINGS =
  time: 0
  tickUp: true
class BoxEntry extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.TOGGLE_LEFT_EARLY
        @find(action.boxId)
        .tap (box) =>
          box.toggleLeftEarly()
        .tap @handleDirty
        .tap @save
      when ActionTypes.TOGGLE_PENALTY_SERVED
        @find(action.boxId)
        .tap (box) =>
          box.toggleServed()
        .tap @handleDirty
        .tap (box) ->
          if box.touch
            box.destroy()
          else
            box.save()
      when ActionTypes.SET_PENALTY_BOX_SKATER
        @find(action.boxId)
        .tap (box) =>
          box.setSkater(action.skaterId)
        .tap @handleDirty
        .tap @save
      when ActionTypes.TOGGLE_PENALTY_TIMER
        @find(action.boxId)
        .tap (box) =>
          box.togglePenaltyTimer()
        .tap @handleDirty
        .tap @save
  @handleDirty: (box) ->
    if not box.dirty
      box.dirty = true
  constructor: (options={}) ->
    super options
    @_clockManager = new ClockManager()
    @teamId = options.teamId
    @leftEarly = options.leftEarly ? false
    @served = options.served ? false
    @position = options.position ? 'blocker'
    @skater = options.skater
    @clock = @_clockManager.getOrAddClock(@id, options.clock ? PENALTY_CLOCK_SETTINGS)
    @dirty = options.dirty ? false
    @sort = options.sort ? 0
  toggleLeftEarly: () ->
    @leftEarly = not @leftEarly
  toggleServed: () ->
    @served = not @served
  togglePenaltyTimer: () ->
    @clock.toggle()
  startPenaltyTimer: () ->
    @clock.start()
  stopPenaltyTimer: () ->
    @clock.stop()
  penaltyTimerIsRunning: () ->
    @clock.isRunning
  setSkater: (skaterId) ->
    Skater.find(skaterId).then (skater) =>
      @skater = skater
module.exports = BoxEntry


