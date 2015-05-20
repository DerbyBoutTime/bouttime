functions = require './functions'
constants = require './constants'
EventEmitter = require('events').EventEmitter
ticks = {}
module.exports =
  ClockManager: class ClockManager
    instance = null
    constructor: (options = {}) ->
      if instance
        return instance
      else
        instance = this
      @clocks = {}
      @lastTick =  null
      @listeners = []
      @refreshRateInMS = options.refreshRateInMs ? constants.CLOCK_REFRESH_RATE_IN_MS
      @emitter = new EventEmitter()
      @initialize()
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
    getOrAddClock: (alias, options = {}) =>
      @getClock(alias) ? @addClock(alias, options)
    addTickListener: (listenerFunction) ->
      @emitter.on("masterTick", listenerFunction)
    removeTickListener: (listenerFunction) ->
      @emitter.removeListener("masterTick", listenerFunction)
    tick: () ->
      tick = Date.now()
      delta = tick - @lastTick
      @lastTick = tick
      for alias, clock of @clocks
        clock.tick(delta) if clock.isRunning
      @issueTick()
    issueTick: () ->
      @emitter.emit("masterTick")
  Clock: class Clock
    constructor: (options = {}) ->
      @id = functions.uniqueId()
      ticks[@id] = null
      @alias = options.alias
      @emitter = new EventEmitter()
      @isSynced = options.isSynced ? false
      @isRunning = options.isRunning ? false
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
      @warningIssued = false
      @expirationIssued = false
      @tickUp = options.tickUp ? false
      @refreshRateInMS = options.refreshRateInMs ? constants.CLOCK_REFRESH_RATE_IN_MS
      @time = @parse(options.time)
      @initialTime = @time
      @warningTime = options.warningTime ? null
    display: () =>
      moment.duration(@time).format('mm:ss')
    parse: (time) =>
      switch typeof time
        when 'string'
          parts = time.split(':')
          while parts.length < 3
            parts.unshift('00')
          time = parts.join(':')
          moment.duration(time).asMilliseconds()
        when 'number'
          time
        else
          0
    issueExpiration: () =>
      @expirationIssued = true
      if @emitter
        @emitter.emit("clockExpiration")
    issueWarning: () =>
      @warningIssued = true
      if @emitter
        @emitter.emit("clockWarning")
    issueTick: () =>
      if @emitter
        @emitter.emit("clockTick")
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