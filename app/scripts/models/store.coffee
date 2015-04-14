Constants = require '../constants.coffee'
Functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
EventEmitter = require('events').EventEmitter

ActionTypes = Constants.ActionTypes
CHANGE_EVENT = 'JAM_CHANGE'

class Store
  @store: {}
  @emitter: new EventEmitter()

  @find: (id) ->
    @store[id]

  @emitChange: () ->
    @emitter.emit(CHANGE_EVENT)

  @addChangeListener: (callback) ->
    @emitter.on(CHANGE_EVENT, callback)

  @removeChangeListener: (callback) ->
    @emitter.removeListener(CHANGE_EVENT, callback)

  constructor: (options={}) ->
    @id = Functions.uniqueId()
    @type = @constructor.name

  save: (options={}) ->
    @constructor.store[@id] = @

module.exports = Store
