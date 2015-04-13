functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
Jam = require './jam.coffee'
class Pass
  @passes: {}

  @find: (id) ->
    @passes[id]

  @findByJamId: (jamId) ->
    (pass for id, pass of @passes when pass.jamId is jamId)

  constructor: (options={}) ->
    @id = functions.uniqueId()
    @jamId = options.jamId
    @passNumber = options.passNumber || 1
    @points = options.points || 0
    @jammerId = options.jammerId
    @injury = options.injury || false
    @lead = options.lead || false
    @lostLead = options.lostLead || false
    @calloff = options.calloff || false
    @nopass = options.nopass || false

  save: () ->
    passes[@id] = this

  getJam: () ->
    Jam.find(@jamId)

module.exports = Pass
