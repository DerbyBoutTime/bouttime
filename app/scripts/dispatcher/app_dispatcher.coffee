{Dispatcher} = require 'flux'
IO = require 'socket.io-client'
class AppDispatcher
  constructor: () ->
    @dispatcher = new Dispatcher()
    @socket = IO('http://localhost:3000')
    @socket.on 'app dispatcher', (payload) =>
      @dispatch(payload)
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