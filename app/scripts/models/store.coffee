_ = require 'underscore'
functions = require '../functions'
config = require '../config'
{EventEmitter} = require 'events'
Promise = require 'bluebird'
Datastore = require 'nedb'
CHANGE_EVENT = 'STORE_CHANGE'
class Store
  @stores = {}
  @emitter: new EventEmitter()
  @_dbOpts: () ->
    if config.server
      filename: "db/#{@name}.db"
      autoload: true
  @_store: () ->
    store = @stores[@name]
    if not store?
      store = new Datastore(@_dbOpts())
      Promise.promisifyAll(store)
      @stores[@name] = store
    store
  @find: (id) ->
    @_store().findOneAsync _id: id
    .then (doc) =>
      if doc? then new this(doc) else null
    .tap @load
  @findOrCreate: (opts={}) ->
    @_store().findOneAsync _id: opts?.id
    .then (doc) =>
      if doc? then new this(doc) else new this(opts)
    .tap @load
  @findBy: (query={}) ->
    @_store().findAsync query
    .map (doc) =>
      this.new(doc)
  @findByOrCreate: (query, opts) ->
    @_store().findAsync query
    .then (docs) ->
      if docs.length > 0
        docs
      else if opts?
        opts.map (opt) ->
          _.extend(opt, query)
      else
        []
    .map (args) =>
      this.new(args)
  @all: () ->
    @findBy()
  @new: (opts={}) ->
    Promise.resolve(new this(opts)).tap @load
  @emitChange: () =>
    @emitter.emit(CHANGE_EVENT)
  @addChangeListener: (callback) ->
    @emitter.on(CHANGE_EVENT, callback)
  @removeChangeListener: (callback) ->
    @emitter.removeListener(CHANGE_EVENT, callback)
  @save: (obj) ->
    obj?.save()
  @load: (obj) ->
    obj?.load()
  @destroy: (obj) ->
    obj?.destroy()
  constructor: (options={}) ->
    @id = options.id ? functions.uniqueId()
    @_id = @id
  load: () ->
    Promise.resolve(this)
  save: (cascade=false, emit=true) ->
    @constructor._store().updateAsync({_id: @_id}, this, {upsert: true})
    .then () =>
      @constructor.emitChange() if emit
    .return this
  destroy: () ->
    @constructor._store().removeAsync({_id: @_id}, {})
    .then @constructor.emitChange
    .return this
module.exports = Store
