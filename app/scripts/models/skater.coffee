functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
Jam = require './jam.coffee'
class Skater
  @skaters: {}

  @find: (id) ->
    @skaters[id]

  @findByTeamId: (teamId) ->
    (skater for id, skater of @skaters when skater.jamId is teamId)

  constructor: (options={}) ->
    @id = functions.uniqueId()
    @teamId = options.teamId
    @name = options.name
    @number = options.number
    @penalties = options.penalties || []

  save: () ->
    skaters[@id] = this

  getJam: () ->
    Jam.find(@jamId)

module.exports = Skater
