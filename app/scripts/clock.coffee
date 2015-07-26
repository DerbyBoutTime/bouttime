moment = require 'moment'
require 'moment-duration-format'
functions = require './functions'
constants = require './constants'
EventEmitter = require('events').EventEmitter
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
        clock.tick(delta)
      @issueTick()
    issueTick: () ->
      @emitter.emit("masterTick")
  Clock: class Clock
    constructor: (options = {}) ->
      @id = functions.uniqueId()
      @alias = options.alias
      @emitter = new EventEmitter()
      @undoStack = if options.undoStack? then new Clock(options.undoStack) else null
      @redoStack = if options.redoStack? then new Clock(options.redoStack) else null
      @dummyUndo = options.dummyUndo ? 0
      @dummyRedo = options.dummyRedo ? 0
      @sync (options)
    start: () =>
      @clearRedo()
      @_pushUndo()
      unless @isRunning
        @isRunning = true
        @lastTick =  Date.now()
    stop: () =>
      @clearRedo()
      @_pushUndo()
      @isRunning = false
    sync: (options={}) ->
      @isRunning = options.isRunning ? false
      @warningIssued = options.warningIssued ? false
      @expirationIssued = options.expirationIssued ? false
      @tickUp = options.tickUp ? false
      @refreshRateInMS = options.refreshRateInMs ? constants.CLOCK_REFRESH_RATE_IN_MS
      @time = @parse(options.time)
      @warningTime = options.warningTime ? null
      @lastTick = Date.now()
    reset: (options) ->
      @clearRedo()
      if options?
        @_pushUndo()
        @sync options
      else
        @dummyUndo++
    undo: () ->
      if @dummyUndo > 0
        @dummyUndo--
        @dummyRedo++
      else
        @_pushRedo()
        @_popUndo()
    redo: () ->
      if @dummyRedo > 0
        @dummyRedo--
        @dummyUndo++
      else
        @_pushUndo()
        @_popRedo()
    isUndoable: () ->
      @undoStack? or @dummyUndo > 0
    isRedoable: () ->
      @redoStack? or @dummyRedo > 0
    clearUndo: () ->
      @undoStack = null
    clearRedo: () ->
      @redoStack = null
    _pushUndo: () ->
      @undoStack = new Clock(this)
      @undoStack.clearRedo()
    _popUndo: () ->
      @sync @undoStack
      @undoStack = @undoStack.undoStack
    _pushRedo: () ->
      @redoStack = new Clock(this)
      @redoStack.clearUndo()
    _popRedo: () ->
      @sync @redoStack
      @redoStack = @redoStack.redoStack
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
      if @isRunning
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
      @undoStack?.tick(delta)
      @redoStack?.tick(delta)