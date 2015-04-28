{Dispatcher} = require 'flux'
config = require '../config'
constants = require '../constants'
IO = require 'socket.io-client'
class AppDispatcher
  constructor: () ->
    @dispatcher = new Dispatcher()
    @timing = {}
    @delays = []
    @delay
    @socket = IO(config.get('socketUrl'))
    console.log "Socket opened on #{@socket.io.uri}"
    @socket.on 'app dispatcher', (payload) =>
      @dispatch(payload)
    @socket.on 'sync games', (payload) =>
      console.log "received sync games"
    @socket.on 'connected', () =>
      console.log "connected"
      @syncClocks()
    @socket.on "clocks synced", (args) =>
      @clocksSynced(args)
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
    ,constants.CLOCK_SYNC_SAMPLE_DURATION_IN_MS)
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
  dispatchAndEmit: (payload) ->
    @dispatch(payload)
    @socket.emit('app dispatcher', payload)
module.exports = new AppDispatcher()