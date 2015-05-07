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
      clock = new CountdownClock(options)
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
        clock.time = 0 if clock.time < 0
        if clock.warningTime && clock.time <= clock.warningTime
          clock.issueWarning()
      @issueTick()
    issueTick: () ->
      args = @serialize()
      func(args) for func in @listeners
    serialize: ()->
      clock.serialize() for alias, clock of @clocks
  CountdownClock: class CountdownClock
    constructor: (options = {}) ->
      @id = functions.uniqueId()
      ticks[@id] = null
      @lastTick =  null
      @time = options.time ? 0
      @initialTime = @time
      @alias = options.alias
      @warningTime = options.warningTime ? null
      @refreshRateInMS = options.refreshRateInMs ? constants.CLOCK_REFRESH_RATE_IN_MS
      @emitter = new EventEmitter()
      @isSynced = options.isSynced ? false
      @isRunning = false
      @warningIssued = false
      @expirationIssued = false
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
    reset: (time = @initialTime) ->
      @time = time
      @lastTick =  Date.now()
      @warningIssued = false
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
      @time = @time - delta
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
      @time = @time - delta
      @time = 0 if @time < 0
      if !@warningIssued && @warningTime && @time <= @warningTime
        @issueWarning()
      if !@expirationIssued && @time == 0
        @issueExpiration()
      @issueTick()