_ = require 'underscore'
functions = require '../functions'
constants = require '../constants'
AppDispatcher = require '../dispatcher/app_dispatcher'
ActionTypes = constants.ActionTypes
{ClockManager} = require '../clock'
Store = require './store'
Jam = require './jam'
Skater = require './skater'
PENALTY_CLOCK_SETTINGS =
  time: constants.PENALTY_DURATION_IN_MS
  warningTime: constants.PENALTY_WARNING_IN_MS
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
        team.setPenaltyBoxSkater(action.boxIndexOrPosition, action.clockId, action.skaterId)
        team.save()
        @emitChange()
      when ActionTypes.ADD_PENALTY_TIME
        team = @find(action.teamId)
        team.addPenaltyTime(action.boxIndex)
        team.save()
        @emitChange()
      when ActionTypes.TOGGLE_PENALTY_TIMER
        team = @find(action.teamId)
        team.togglePenaltyTimer(action.boxIndex)
        team.save()
        @emitChange()
      when ActionTypes.TOGGLE_ALL_PENALTY_TIMERS
        team = @find(action.teamId)
        team.toggleAllPenaltyTimers()
        team.save()
        @emitChange()
  constructor: (options={}) ->
    super options
    @name = options.name
    @initials = options.initials
    @colorBarStyle = options.colorBarStyle ? { backgroundColor: '', color: '' }
    @logo = options.logo
    @officialReviewsRetained = options.officialReviewsRetained ? 0
    @isTakingOfficialReview = options.isTakingOfficialReview ? false
    @isTakingTimeout = options.isTakingTimeout ? false
    @hasOfficialReview = options.hasOfficialReview ? true
    @timeouts = options.timeouts ? 3
    _skaters = @getSkaters()
    if _skaters.length > 0
      @skaters = _skaters
    else if options.skaters?
      @skaters = (new Skater(_.extend(skater, teamId: @id)) for skater in options.skaters)
    else
      @skaters = []
    _jams = @getJams()
    if _jams.length > 0
      @jams = _jams
    else if options.jams?
      @jams = (new Jam(_.extend(jam, teamId: @id)) for jam in options.jams)
    else
      @jams = [new Jam(teamId: @id)]
    @penaltyBoxStates = options.penaltyBoxStates ? []
    @clockManager = new ClockManager()
    for boxState in @penaltyBoxStates
      boxState.clock = @clockManager.getOrAddClock(boxState.clock.alias, boxState.clock)
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
    skater.teamId = @id
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
  createJamsThrough: (jamNumber) ->
    for i in [@jams.length+1 .. jamNumber] by 1
      @createNextJam()
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
  addPenaltyTime: (boxIndex)->
    box = @penaltyBoxStates[boxIndex]
    if box?
      box.penaltyCount += 1
      box.clock.time += constants.PENALTY_DURATION_IN_MS
  togglePenaltyTimer: (boxIndex) ->
    box = @penaltyBoxStates[boxIndex]
    if box?
      if box.clock.isRunning then box.clock.stop() else box.clock.start()
  anyPenaltyTimerRunning: () ->
    @penaltyBoxStates.some (boxState) ->
      boxState.clock.isRunning
  toggleAllPenaltyTimers: () ->
    if @anyPenaltyTimerRunning()
      boxState.clock.stop() for boxState in @penaltyBoxStates
    else
      boxState.clock.start() for boxState in @penaltyBoxStates
  setPenaltyBoxSkater: (boxIndexOrPosition, clockId, skaterId) ->
    box = @getOrCreatePenaltyBoxState(boxIndexOrPosition, clockId)
    skater = Skater.find(skaterId)
    box.skater = skater
  newPenaltyBoxState: (position, clockId) ->
    position: position
    penaltyCount: 1
    clock: @clockManager.addClock(clockId ? functions.uniqueId(), PENALTY_CLOCK_SETTINGS)
  getOrCreatePenaltyBoxState: (boxIndexOrPosition, clockId) ->
    switch typeof boxIndexOrPosition
      when 'number'
        @penaltyBoxStates[boxIndexOrPosition]
      when 'string'
        box = @newPenaltyBoxState(boxIndexOrPosition, clockId)
        @penaltyBoxStates.push(box)
        box
  startTimeout: () ->
    @timeouts -= 1
    @isTakingTimeout = true
  removeOfficialReview: () ->
    @hasOfficialReview = false
    @officialReviewsRetained -= 1
  restoreOfficialReview: () ->
    @hasOfficialReview = true
    @officialReviewsRetained += 1
module.exports = Team
