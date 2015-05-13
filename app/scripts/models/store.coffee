Constants = require '../constants'
Functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
EventEmitter = require('events').EventEmitter
ActionTypes = Constants.ActionTypes
CHANGE_EVENT = 'JAM_CHANGE'
class Store
  @store: localStorage
  @emitter: new EventEmitter()
  @find: (id) ->
    return null if not id?
    obj = JSON.parse(@store.getItem(id))
    if obj then new this(obj) else null
  @findBy: (opts={}) ->
    predicate = (obj) =>
      match = (obj.type is @name)
      for key, val of opts
        match &= (obj[key] is val)
      match
    matches = []
    for id, json of @store
      if typeof json is 'string' and json isnt 'undefined'
        obj = JSON.parse(json)
        matches.push(new this(obj)) if predicate(obj)
    matches
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
      @constructor.store.setItem(@id, JSON.stringify(this))
    else
      @constructor.store.removeItem(@id)
  destroy: () ->
    @_destroy = true
module.exports = Store
