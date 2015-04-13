functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
Pass = require './pass.coffee'
Team = require './team.coffee'
class Jam
  @jams: {}

  @find: (id) ->
    @jams[id]

  @findByTeamId: (teamId) ->
    (jam for id, jam of @jams when jam.teamId is teamId)

  constructor: (options={}) ->
    @id = functions.uniqueId()
    @teamId = options.teamId
    @jamNumber = options.jamNumber || 1
    @noPivot = options.noPivot || false
    @starPass = options.noPivot || false
    @pivotId = options.pivotId
    @blocker1Id = options.blocker1Id
    @blocker2Id = options.blocker2Id
    @blocker3Id = options.blocker3Id
    @jammerId = options.jammerId
    @passes = options.passes || [new Pass(jamId: @id)]
    @lineupStatuses = options.lineupStatuses || []

  save: () ->
    jams[@id] = this

  getTeam: () ->
    Team.find(@teamId)

  getPasses: () ->
    Pass.findByJamId(@id)

module.exports = Jam
