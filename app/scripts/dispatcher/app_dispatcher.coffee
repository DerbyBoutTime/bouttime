invariant = require 'invariant'
Promise = require 'bluebird'
config = require '../config'
constants = require '../constants'
IO = require 'socket.io-client'
class AppDispatcher
  constructor: () ->
    @_lastId = 1
    @_callbacks = {}
    @_promises = {}
    @_dispatch = null
    @_timing = {}
    @_delays = []
    @_delay = 0
    @_socket = IO(config.get('socketUrl'))
    @_socket.on 'app dispatcher', (payload) =>
      if payload.sourceDelay?
        payload.destinationDelay = @_delay
      @dispatch(payload)
    @_socket.on 'connected', () =>
      console.log "connected"
      @syncClocks()
    @_socket.on "clocks synced", (args) =>
      @clocksSynced(args)
  syncGame: (gameId) ->
    @_socket.emit 'sync game', gameId: gameId
  syncClocks: () ->
    @_timing.A = new Date().getTime()
    @_socket.emit 'sync clocks', {}
  clocksSynced: (args) =>
    @_timing.B = new Date().getTime()
    @_timing.X = args.timeX
    @_timing.Y = args.timeY
    @_delays.push(@_timing.B - @_timing.A - (@_timing.Y - @_timing.X))
    @_delay = @_delays.reduce((b,c)->
      return b+c
    )/@_delays.length
    console.log "Delay is #{@_delay}ms"
    setTimeout(() =>
      @syncClocks()
    ,constants.CLOCK_SYNC_SAMPLE_DURATION_IN_MS*constants.CLOCK_SYNC_SAMPLE_DURATION_MULTIPLIER**@_delays.length)
  register: (callback) ->
    id = @_lastId++
    @_callbacks[id] = callback
    id
  unregister: (id) ->
    invariant(
      @_callbacks[id],
      'Dispatcher.unregister(...) `%s` does not map to a registered callback.',
      id)
    delete this_callbacks[id];
  waitFor: (ids) ->
    invariant(
      @isDispatching(),
      'Dispatcher.waitFor(...): Must be invoked while dispatching.')
    Promise.map ids, (id) =>
      invariant(
        @_callbacks[id],
        'Dispatcher.waitFor(...): `%s` does not map to a registered callback.',
        id)
      @_promises[id]
  dispatch: (payload) ->
    invariant(
      not @_isDispatching,
      'Dispatcher.dispatch(...): Cannot dispatched in the middle of a dispatch.')
    console.log payload
    @_dispatch = Promise.resolve(payload)
    .then (payload) =>
      @_promises = {}
      for id, callback of @_callbacks
        @_promises[id] = callback(payload)
      @_promises
    .props()
  isDispatching: () ->
    @_dispatch?.isPending()
  emit: (payload) ->
    @_socket.emit('app dispatcher', payload)
  dispatchAndEmit: (payload) ->
    @dispatch(payload)
    @emit(payload)
module.exports = new AppDispatcher()