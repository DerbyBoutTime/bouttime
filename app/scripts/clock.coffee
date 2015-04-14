functions = require './functions.coffee'
constants = require './constants.coffee'
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
      @refreshRateInMS = options.refreshRateInMs ? 500
      @selector = options.selector ? null
      @isSynced = options.isSynced ? false
      @isRunning = false
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
    display: () =>
      functions.toClock(@time, false)
    buildEventOptions: () =>
      id: @id
      time: @time
      display: @display()
    issueWarning: () =>
      if @selector
        $(@selector).trigger "countdownWarning", @buildEventOptions()
    issueTick: () =>
      if @selector
        $(@selector).trigger "tick", @buildEventOptions()
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
      if @warningTime && @time <= @warningTime
        @issueWarning()
      @issueTick()
    _tick: () =>
      tick = Date.now()
      delta = tick - @lastTick
      @lastTick = tick
      @time = @time - delta
      @time = 0 if @time < 0
      if @warningTime && @time <= @warningTime
        @issueWarning()
      @issueTick()