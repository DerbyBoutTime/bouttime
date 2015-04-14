functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../constants.coffee'
Store = require './store.coffee'
Jam = require './jam.coffee'
Skater = require './skater.coffee'
class Team extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.CREATE_NEXT_JAM
        team = @find(action.teamId)
        team.createNextJam()
        team.save()
        @emitChange()
    switch action.type
      when ActionTypes.TOGGLE_LEFT_EARLY
        team = @find(action.teamId)
        team.toggleLeftEarly(action.boxIndex)
        team.save()
        @emitChange()
      when ActionTypes.TOGGLE_PENALTY_SERVED
        team = @find(action.teamId)
        team.toggleServed(action.boxIndex)
        team.save()
        @emitChange()
      when ActionTypes.SET_PENALTY_BOX_SKATER
        team = @find(action.teamId)
        team.setPenaltyBoxSkater(action.boxIndexOrPosition, action.skaterId)
        team.save()
        @emitChange()
  constructor: (options={}) ->
    super options
    @name = options.name
    @initials = options.initials
    @colorBarStyle = options.colorBarStyle
    @logo = options.logo
    @isTakingOfficialReview = options.isTakingOfficialReview || false
    @isTakingTimeout = options.isTakingTimeout || false
    @hasOfficialReview = options.hasOfficialReview || true
    @timeouts = options.timeouts || 3
    for skater in options.skaters || []
      skater.teamId = @id
      skater.save()
    for jam in options.jams || [new Jam()]
      jam.teamId = @id
      jam.save()
    @penaltyBoxStates = options.penaltyBoxStates || []
  save: () ->
    super()
    skater.save() for skater in @getSkaters()
    jam.save() for jam in @getJams()
  getJams: () ->
    Jam.findByTeamId(@id).sort (a, b) ->
      a.jamNumber - b.jamNumber
  getSkaters: () ->
    Skater.findByTeamId(@id)
  getPoints: () ->
    @getJams().reduce ((sum, jam) -> sum += jam.getPoints()), 0
  createNextJam: () ->
    jams = @getJams()
    lastJam = jams[jams.length - 1]
    newJam = new Jam(jamNumber: lastJam.jamNumber + 1, teamId: @id)
    positionsInBox = lastJam.getPositionsInBox()
    if positionsInBox.length > 0
      newJam.lineupStatuses[0] = {}
      for position in positionsInBox
        newJam[position] = lastJam[position]
        newJam.lineupStatuses[0][position] = 'sat_in_box'
    newJam.save()
  toggleLeftEarly: (boxIndex) ->
    box = @penaltyBoxStates[boxIndex]
    if box?
      box.leftEarly = !box.leftEarly
      box.served = false
  toggleServed: (boxIndex) ->
    box = @penaltyBoxStates[boxIndex]
    if box?
      box.served = !box.served
      box.leftEarly = false
  setPenaltyBoxSkater: (boxIndexOrPosition, skaterId) ->
    box = @getOrCreatePenaltyBoxState(boxIndexOrPosition)
    skater = Skater.find(skaterId)
    box.skater = skater
  newPenaltyBoxState: (position) ->
    position: position
  getOrCreatePenaltyBoxState: (boxIndexOrPosition) ->
    switch typeof boxIndexOrPosition
      when 'number'
        @penaltyBoxStates[boxIndexOrPosition]
      when 'string'
        box = @newPenaltyBoxState(boxIndexOrPosition)
        @penaltyBoxStates.push(box)
        box
module.exports = Team
