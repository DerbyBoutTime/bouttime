functions = require './functions'
constants = require './constants'
EventEmitter = require('events').EventEmitter
ticks = {}
module.exports =
  ClockManager: class ClockManager
    constructor: (options = {}) ->
      @clocks = {}
      @lastTick =  null
      @listeners = []
      @refreshRateInMS = options.refreshRateInMs ? constants.CLOCK_REFRESH_RATE_IN_MS
    initialize: () ->
      @lastTick = Date.now()
      exports.clockManagerInterval = setInterval(() =>
        @tick()
      ,@refreshRateInMS)
    destroy: () ->
      clearInterval exports.clockManagerInterval
      exports.clockManagerInterval = null
    addClock: (alias, options = {}) =>
      options.isSynced = true
      options.alias = alias
      clock = new Clock(options)
      @clocks[alias] = clock
    removeClock: (alias) ->
      delete @clocks[alias]
    getClock: (alias) ->
      @clocks[alias]
    addTickListener: (listenerFunction) ->
      @listeners.push(listenerFunction)
    tick: () ->
      tick = Date.now()
      delta = tick - @lastTick
      @lastTick = tick
      for alias, clock of @clocks
        clock.tick(delta) if clock.isRunning
      @issueTick()
    issueTick: () ->
      args = @serialize()
      func(args) for func in @listeners
    serialize: ()->
      h = {}
      h[alias] = clock.serialize() for alias, clock of @clocks
      h
  Clock: class Clock
    constructor: (options = {}) ->
      @id = functions.uniqueId()
      ticks[@id] = null
      @alias = options.alias
      @emitter = new EventEmitter()
      @isSynced = options.isSynced ? false
      @reset (options)
    start: () =>
      @stop() #Clear to prevent lost interval function
      @isRunning = true
      @lastTick =  Date.now()
      unless @isSynced
        ticks[@id] = setInterval(() =>
          @_tick()
        ,@refreshRateInMS)
    stop: () =>
      @isRunning = false
      unless @isSynced
        clearInterval ticks[@id]
        ticks[@id] = null
    reset: (options={}) ->
      @stop()
      @warningIssued = false
      @expirationIssued = false
      @tickUp = options.tickUp ? false
      @refreshRateInMS = options.refreshRateInMs ? constants.CLOCK_REFRESH_RATE_IN_MS
      @time = options.time ? 0
      @initialTime = @time
      @warningTime = options.warningTime ? null
    display: () =>
      functions.toClock(@time, false)
    buildEventOptions: () =>
      id: @id
      time: @time
      display: @display()
    issueExpiration: () =>
      @expirationIssued = true
      if @emitter
        @emitter.emit("clockExpiration", @buildEventOptions())
    issueWarning: () =>
      @warningIssued = true
      if @emitter
        @emitter.emit("clockWarning", @buildEventOptions())
    issueTick: () =>
      if @emitter
        @emitter.emit("clockTick", @buildEventOptions())
    serialize: () =>
      {
        id: @id
        alias: @alias
        display: @display()
        time: @time
      }
    tick: (delta) ->
      # Synchronize with master tick
      if @lastTick
        delta = (Date.now() - @lastTick)
        @lastTick = null
      # Adjust time
      @time = if @tickUp then @time + delta else @time - delta
      @time = 0 if @time < 0
      if !@warningIssued && @warningTime && @time <= @warningTime
        @issueWarning()
      if !@expirationIssued && @time == 0
        @issueExpiration()
      @issueTick()
    _tick: () =>
      tick = Date.now()
      delta = tick - @lastTick
      @lastTick = tick
      @tick(delta)