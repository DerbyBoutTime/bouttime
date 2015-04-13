functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
Jam = require './jam.coffee'
Skater = require './skater.coffee'
class Team
  @teams: {}

  @find: (id) ->
    @teams[id]

  constructor: (options={}) ->
    @id = functions.uniqueId()
    @name = options.name
    @initials = options.initials
    @colorBarStyle = options.colorBarStyle
    @logo = options.logo
    @isTakingOfficialReview = options.isTakingOfficialReview || false
    @isTakingTimeout = options.isTakingTimeout || false
    @hasOfficialReview = options.hasOfficialReview || false
    @timeouts = options.timeouts || 3
    @skaters = options.skaters || []
    for skater in @skaters
      skater.teamId = @id
    @jams = options.jams || [new Jam()]
    for jam in @jams
      jam.teamId = @id
    @penaltyBoxStates = options.penaltyBoxStates || []

  save: () ->
    teams[@id] = this

  getJams: () ->
    Jam.findByTeamId(@id)

  getSkaters: () ->
    Skater.findByTeamId(@id)

module.exports = Team
