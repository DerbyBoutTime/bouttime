Constants = require '../constants'
Functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
EventEmitter = require('events').EventEmitter
ActionTypes = Constants.ActionTypes
CHANGE_EVENT = 'JAM_CHANGE'
class Store
  @store: {}
  @emitter: new EventEmitter()
  @find: (id) ->
    @store[id]
  @all: () ->
    (obj for id, obj of @store when obj.type is @name)
  @emitChange: () ->
    @emitter.emit(CHANGE_EVENT)
  @addChangeListener: (callback) ->
    @emitter.on(CHANGE_EVENT, callback)
  @removeChangeListener: (callback) ->
    @emitter.removeListener(CHANGE_EVENT, callback)
  constructor: (options={}) ->
    @id = options.id || Functions.uniqueId()
    @type = @constructor.name
    @_destroy = false
  save: (options={}) ->
    #console.log("Saving #{@constructor.name} #{@id}")
    if not @_destroy
      @constructor.store[@id] = this
    else
      delete @constructor.store[@id]
  destroy: () ->
    @_destroy = true
module.exports = Store
