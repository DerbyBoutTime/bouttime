functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
Jam = require './jam'
Skater = require './skater'
class Team extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.CREATE_NEXT_JAM
        team = @find(action.teamId)
        team.createNextJam()
        team.save()
        @emitChange()
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
    @colorBarStyle = options.colorBarStyle || { backgroundColor: '', color: '' }
    @logo = options.logo
    @officialReviewsRetained = options.officialReviewsRetained || 0
    @isTakingOfficialReview = options.isTakingOfficialReview || false
    @isTakingTimeout = options.isTakingTimeout || false
    @hasOfficialReview = options.hasOfficialReview || true
    if options.timeouts?
      @timeouts = options.timeouts
    else
      @timeouts = 3
    _skaters = @getSkaters()
    if _skaters.length > 0
      @skaters = _skaters
    else if options.skaters?
      @skaters = (new Skater(skater) for skater in options.skaters)
    else
      @skaters = []
    _jams = @getJams()
    if _jams.length > 0
      @jams = _jams
    else if options.jams?
      @jams = (new Jam(jam) for jam in options.jams)
    else
      @jams = [new Jam(teamId: @id)]
    @penaltyBoxStates = options.penaltyBoxStates || []
  save: () ->
    super()
    skater.save() for skater in @skaters
    jam.save() for jam in @jams
  getJams: () ->
    Jam.findBy(teamId: @id).sort (a, b) ->
      a.jamNumber - b.jamNumber
  getSkaters: () ->
    Skater.findBy(teamId: @id)
  addSkater: (skater) ->
    @skaters.push skater
  removeSkater: (skater) ->
    @skaters = (s for s in @skaters when s.id isnt skater.id)
    skater.destroy()
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
    @jams.push newJam
    AppDispatcher.emit
      type: ActionTypes.SAVE_JAM
      jam: newJam
    newJam
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
