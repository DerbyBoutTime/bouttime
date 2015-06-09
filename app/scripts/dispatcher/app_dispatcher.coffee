{Dispatcher} = require 'flux'
config = require '../config'
constants = require '../constants'
IO = require 'socket.io-client'
class AppDispatcher
  constructor: () ->
    @dispatcher = new Dispatcher()
    @timing = {}
    @delays = []
    @delay = 0
    @socket = IO(config.get('socketUrl'))
    @socket.on 'app dispatcher', (payload) =>
      if payload.sourceDelay?
        payload.destinationDelay = @delay
      @dispatch(payload)
    @socket.on 'connected', () =>
      console.log "connected"
      @syncClocks()
    @socket.on "clocks synced", (args) =>
      @clocksSynced(args)
  syncGame: (gameId) ->
    @socket.emit 'sync game', gameId: gameId
  syncClocks: () ->
    @timing.A = new Date().getTime()
    @socket.emit 'sync clocks', {}
  clocksSynced: (args) =>
    @timing.B = new Date().getTime()
    @timing.X = args.timeX
    @timing.Y = args.timeY
    @delays.push(@timing.B - @timing.A - (@timing.Y - @timing.X))
    @delay = @delays.reduce((b,c)->
      return b+c
    )/@delays.length
    console.log "Delay is #{@delay}ms"
    setTimeout(() =>
      @syncClocks()
    ,constants.CLOCK_SYNC_SAMPLE_DURATION_IN_MS*constants.CLOCK_SYNC_SAMPLE_DURATION_MULTIPLIER**@delays.length)
  register: (callback) ->
    @dispatcher.register(callback)
  unregister: (id) ->
    @dispatcher.unregister(id)
  waitFor: (ids) ->
    @dispatcher.waitFor(ids)
  dispatch: (payload) ->
    console.log("Dispatching")
    console.log payload
    @dispatcher.dispatch(payload)
  isDispatching: () ->
    @dispatcher.isDispatching()
  emit: (payload) ->
    @socket.emit('app dispatcher', payload)
  dispatchAndEmit: (payload) ->
    @dispatch(payload)
    @emit(payload)
module.exports = new AppDispatcher()