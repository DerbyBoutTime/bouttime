exports = exports ? this
exports.ticks = exports.ticks ? {}
exports.classes = exports.classes ? {}
exports.classes.CountdownClock = class CountdownClock
  constructor: (options = {}) ->
    @id = exports.wftda.functions.uniqueId()
    exports.ticks[@id] = null
    @tick = null
    @time = options.time ? 0
    @initialTime = @time
    @warningTime = options.warningTime ? null
    @refreshRateInMS = options.refreshRateInMs ? 500
    @selector = options.selector ? null
  start: () =>
    @stop() #Clear to prevent lost interval function
    @tick = Date.now()
    exports.ticks[@id] = setInterval(() =>
      @_tick()
    ,@refreshRateInMS)
  stop: () =>
    clearInterval exports.ticks[@id]
    exports.ticks[@id] = null
  isRunning: () =>
    exports.ticks[@id] != null
  reset: (time = @initialTime) ->
    @stop()
    @time = time
    @tick = null
  display: () =>
    exports.wftda.functions.toClock(@time, false)
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
      display: @display()
      time: @time
      tick: @tick
    }
  _tick: () =>
    #console.log("tick  clock")
    tick = Date.now()
    Delta = tick - @tick
    @tick = tick
    @time = @time - Delta
    @time = 0 if @time < 0
    if @warningTime && @time <= @warningTime
      @issueWarning()
    @issueTick()